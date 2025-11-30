import ProjectDescription

let config = Config(
    project: .tuist(
        plugins: [
            .git(
                url: "https://github.com/AckeeCZ/AckeeTemplate-TuistPlugin",
                tag: "0.3.1"
            )
        ]
    )
)