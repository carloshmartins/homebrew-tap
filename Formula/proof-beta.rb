class ProofBeta < Formula
  desc "Is this branch safe to merge? One verdict from an iPhone simulator and an Android emulator"
  homepage "https://github.com/carloshmartins/proof-beta"
  version "1.0.0-beta.1"

  # The beta releases are private: the download is authorised with HOMEBREW_GITHUB_API_TOKEN or, without
  # it, the GitHub CLI's token (gh auth login) of an account that was invited to the beta.
  def self.github_token
    token = ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s
    gh = "#{HOMEBREW_PREFIX}/bin/gh"
    token = `#{gh} auth token 2>/dev/null`.strip if token.empty? && File.executable?(gh)
    token
  end

  url "https://api.github.com/repos/carloshmartins/proof-beta/releases/assets/748638664",
      headers: ["Accept: application/octet-stream", "Authorization: Bearer #{github_token}"]
  sha256 "a450b81b9a96df7719d01be9071ed2b09c379f0842626e2c6a9b21a3a6e3e29d"

  depends_on :macos

  conflicts_with "proof", because: "both install a `proof` binary"

  def install
    bin.install "proof"
    (share/"proof").install "Runner", "skill"
  end

  def caveats
    <<~EOS
      Next, in your app:
        proof init && proof doctor && proof check
      or type `proof` for the interactive interface. `proof skill install` adds the agent skill.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proof --version")
  end
end
