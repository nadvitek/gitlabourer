import SwiftUI
import GitLabourerUI

struct RepositoryBranchPickerView: View {

    @Binding private var selectedBranch: String
    let branches: [String]

    init(
        selectedBranch: Binding<String>,
        branches: [String]
    ) {
        self._selectedBranch = selectedBranch
        self.branches = branches
    }

    var body: some View {
        Picker(
            "Label",
            selection: $selectedBranch
        ) {
            ForEach(branches, id:\.self) {
                Text($0.description)
                    .tag($0)
            }
        }
        .pickerStyle(.automatic)
        .opacity(0.1)
        .overlay {
            Button {

            } label: {
                HStack(spacing: 6) {
                    Text(selectedBranch)
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Image(systemName: "arrowtriangle.down.fill")
                        .resizable()
                        .frame(width: 13, height: 8)
                }
                .foregroundStyle(GitlabColors.gitlabDark.swiftUIColor)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(GitlabColors.gitlabOrangeTwo.swiftUIColor)
                .clipShape(.capsule)
            }
            .allowsHitTesting(false)
        }
    }
}

#if DEBUG

// MARK: - Previews

struct RepositoryBranchPickerView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryBranchPickerView(
            selectedBranch: .constant("development"),
            branches: [
                "development",
                "feature/rosta",
                "fix/verca",
                "fix/luky",
                "fix/vítek",
                "fix/simi",
                "fix/tom",
                "fix/hynek"
            ]
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gitlabourerBackground()
        .preferredColorScheme(.dark)
    }
}

#endif
