# Homebrew formula template, rendered by packaging/release into dist/merkhain.rb
# from the GoReleaser archives and SHA256SUMS. Not published anywhere: at launch
# the rendered file goes into the merkhain/homebrew-tap repository
# (docs/development/distribution.md).
class Merkhain < Formula
  desc "Durable, private, collaborative memory for coding agents"
  homepage "https://merkhain.com"
  version "0.0.8"

  on_macos do
    on_arm do
      url "https://github.com/merkhain/releases/releases/download/v0.0.8/merkhain_0.0.8_darwin_arm64.tar.gz"
      sha256 "0b92576f90f5c9ff7eabbf74f350bcd3708a368a2d988aa2ddd750c13333ef72"
    end
    on_intel do
      url "https://github.com/merkhain/releases/releases/download/v0.0.8/merkhain_0.0.8_darwin_amd64.tar.gz"
      sha256 "b96b770477fe9b6e6d3f782ed49e81e74cb2494ca080be6974d23088ee53bc34"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/merkhain/releases/releases/download/v0.0.8/merkhain_0.0.8_linux_arm64.tar.gz"
      sha256 "cb76f35a58ecfdb9a9891bb8d3def12519a60eb2f1e250da81ab584f1ccb92e9"
    end
    on_intel do
      url "https://github.com/merkhain/releases/releases/download/v0.0.8/merkhain_0.0.8_linux_amd64.tar.gz"
      sha256 "ad149d6922cc01d83c9beb9bd5f9ee7629cef64ec5d86b60e2be88acf8f9bf22"
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

  # The launcher runs serve local and activates the next `brew upgrade`
  # itself (merkhain supervise; docs/guide/upgrade.md).
  service do
    run [opt_bin/"merkhain", "supervise", "local", "--install-path", opt_bin/"merkhain"]
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
