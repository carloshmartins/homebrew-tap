class Proof < Formula
  desc "Prove iOS changes work: condensed builds, simulator control, stacked-PR tests"
  homepage "https://carloshmartins.github.io/proof"
  url "https://github.com/carloshmartins/proof/archive/refs/tags/0.3.0.tar.gz"
  sha256 "6db93c2b6002238a0b04c8f11334aa84a5caa9ada189e5908354e1e1b5cdc7e5"
  license "Apache-2.0"
  head "https://github.com/carloshmartins/proof.git", branch: "main"

  depends_on macos: :sonoma
  depends_on xcode: "16.0"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "proof"
    bin.install ".build/release/proof"
    # proof setup and the simulator runner look for these in ../share/proof next to the binary.
    pkgshare.install "Runner", "skill"
  end

  def caveats
    <<~EOS
      Teach your coding agent to use proof (installs the agent skill):
        proof setup
      For an agent that reads skills from another folder:
        proof setup --skill-dir <its skills folder>/proof

      Then, once per app, from its repository:
        proof init --scheme <Scheme> --simulator "iPhone 16"

      Docs: https://carloshmartins.github.io/proof
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proof --version")
    assert_path_exists pkgshare/"Runner/ProofRunner.xcodeproj"
    assert_path_exists pkgshare/"skill/proof/SKILL.md"
  end
end
