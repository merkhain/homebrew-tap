# Homebrew formula template, rendered by packaging/release into dist/merkhain.rb
# from the GoReleaser archives and SHA256SUMS. Not published anywhere: at launch
# the rendered file goes into the merkhain/homebrew-tap repository
# (docs/development/distribution.md).
class Merkhain < Formula
  desc "Durable, private, collaborative memory for coding agents"
  homepage "https://merkhain.com"
  version "0.0.4"

  on_macos do
    on_arm do
      url "https://github.com/merkhain/releases/releases/download/v0.0.4/merkhain_0.0.4_darwin_arm64.tar.gz"
      sha256 "ac9196b8181ced1bf63c6a214571d0946594940bea31395defec40101f221f99"
    end
    on_intel do
      url "https://github.com/merkhain/releases/releases/download/v0.0.4/merkhain_0.0.4_darwin_amd64.tar.gz"
      sha256 "99ef963e45025dcf8717bb531b0302ea953b77d0bd79d3ba95b77da73192be0f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/merkhain/releases/releases/download/v0.0.4/merkhain_0.0.4_linux_arm64.tar.gz"
      sha256 "1f5a5edd42d805ee2bd55db494271ae6a4ffbc025492bae72ca5004b68618e86"
    end
    on_intel do
      url "https://github.com/merkhain/releases/releases/download/v0.0.4/merkhain_0.0.4_linux_amd64.tar.gz"
      sha256 "bc1e86f78703f2d84df97be60710645568f20b543b8fa2d152bb169823f87c08"
    end
  end

  def install
    bin.install "merkhain"
    if OS.mac?
      (share/"merkhain").install "share/launchd/ai.merkhain.local.plist"
    else
      (share/"merkhain").install Dir["share/systemd/*"]
    end
  end

  service do
    run [opt_bin/"merkhain", "serve", "local"]
    keep_alive successful_exit: false
    environment_variables PATH: std_service_path_env
    log_path var/"log/merkhain-local.log"
    error_log_path var/"log/merkhain-local.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/merkhain version")
    ENV["MERKHAIN_HOME"] = testpath.to_s
    assert_match "merkhain.db", shell_output("#{bin}/merkhain config")
  end
end
