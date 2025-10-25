package com.jetbrains.kmpapp.feature.repository.domain.model

public data class TreeItem(
    val sha: String,
    val name: String,
    val path: String,
    val mode: String,
    val kind: Kind,
    var children: List<TreeItem> = emptyList()
) {
    public enum class Kind { FILE, DIRECTORY, SUBMODULE }
}

internal fun List<TreeItem>.toHierarchicalTree(): List<TreeItem> {
    // Internal mutable node to build the tree first, then freeze to TreeItem
    data class Node(
        val sha: String,
        val name: String,
        val path: String,
        val mode: String,
        val kind: TreeItem.Kind,
        val children: MutableList<Node> = mutableListOf()
    )

    fun parentPath(path: String): String? =
        path.substringBeforeLast('/', missingDelimiterValue = "").ifEmpty { null }

    // Map by full path for O(1) parent lookups
    val byPath = mutableMapOf<String, Node>()

    // Build nodes from flat list
    for (item in this) {
        // Create or update existing node (avoid duplicate path churn)
        val node = byPath.getOrPut(item.path) {
            Node(item.sha, item.name, item.path, item.mode, item.kind)
        }

        // If a parent exists, attach to it. If not, ensure the parent chain exists.
        var pPath = parentPath(item.path)
        if (pPath != null) {
            // Walk upwards creating virtual dirs when missing (rare with GitLab, but safe).
            var child = node
            var cur = pPath
            while (cur != null) {
                val parent = byPath.getOrPut(cur) {
                    val parentName = cur.substringAfterLast('/', cur)
                    Node(
                        sha = "",
                        name = parentName,
                        path = cur,
                        mode = "040000",
                        kind = TreeItem.Kind.DIRECTORY
                    )
                }
                // Link once
                if (child !in parent.children) parent.children += child
                // Continue climbing only if parent already linked upwards; otherwise link chain
                val next = parentPath(cur)
                // Prepare for next loop
                child = parent
                cur = next
            }
        }
    }

    // Determine roots: nodes without a parent are roots.
    // Build a reverse index of children to mark non-roots.
    val hasParent = mutableSetOf<String>()
    byPath.values.forEach { parent -> parent.children.forEach { hasParent += it.path } }
    val roots = byPath.values.filter { it.path !in hasParent && parentPath(it.path) == null }

    // Sorting: dir (0) < file (1) < submodule (2), then case-insensitive name
    fun orderKey(kind: TreeItem.Kind) = when (kind) {
        TreeItem.Kind.DIRECTORY -> 0
        TreeItem.Kind.FILE -> 1
        TreeItem.Kind.SUBMODULE -> 2
    }
    fun sortRec(node: Node) {
        node.children.sortWith(
            compareBy<Node> { orderKey(it.kind) }.thenBy { it.name.lowercase() }
        )
        node.children.forEach(::sortRec)
    }
    roots.forEach(::sortRec)

    // Freeze to immutable TreeItem recursively
    fun freeze(node: Node): TreeItem =
        TreeItem(
            sha = node.sha,
            name = node.name,
            path = node.path,
            mode = node.mode,
            kind = node.kind,
            children = node.children.map(::freeze)
        )

    return roots
        .sortedWith(compareBy<Node> { orderKey(it.kind) }.thenBy { it.name.lowercase() })
        .map(::freeze)
}
