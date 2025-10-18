package com.jetbrains.kmpapp.feature.project.domain.model

public sealed class AvatarResult {
    public data class Fresh(
        val bytes: ByteArray,
        val mimeType: String?,
        val fileName: String?,
        val eTag: String?,
        val lastModified: String?
    ) : AvatarResult() {

        override fun equals(other: Any?): Boolean {
            if (this === other) return true
            if (other == null || this::class != other::class) return false

            other as Fresh

            if (!bytes.contentEquals(other.bytes)) return false
            if (mimeType != other.mimeType) return false
            if (fileName != other.fileName) return false
            if (eTag != other.eTag) return false
            if (lastModified != other.lastModified) return false

            return true
        }

        override fun hashCode(): Int {
            var result = bytes.contentHashCode()
            result = 31 * result + (mimeType?.hashCode() ?: 0)
            result = 31 * result + (fileName?.hashCode() ?: 0)
            result = 31 * result + (eTag?.hashCode() ?: 0)
            result = 31 * result + (lastModified?.hashCode() ?: 0)
            return result
        }
    }

    public object NotModified : AvatarResult() // if you use ETag/If-None-Match
}
