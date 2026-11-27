# Homebrew formula template, rendered by packaging/release into dist/merkhain.rb
# from the GoReleaser archives and SHA256SUMS. Release finalization publishes
# the verified formula to merkhain/homebrew-tap (docs/development/distribution.md).
class Merkhain < Formula
  desc "Durable, private, collaborative memory for coding agents"
  homepage "https://merkhain.com"
  version "0.0.9"

  on_macos do
    on_arm do
      url "https://github.com/merkhain/releases/releases/download/v0.0.9/merkhain_0.0.9_darwin_arm64.tar.gz"
      sha256 "2ddfe4f216462d5f343c409c4cc25af807bf7f7eb9936a487531592e2ba96fb1"
    end
    on_intel do
      url "https://github.com/merkhain/releases/releases/download/v0.0.9/merkhain_0.0.9_darwin_amd64.tar.gz"
      sha256 "6334a28803db9badbae28ffe4e4ffc3379692b54cf78114474703a96d84af3dd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/merkhain/releases/releases/download/v0.0.9/merkhain_0.0.9_linux_arm64.tar.gz"
      sha256 "85bd9a6e6a31a1e4b483d3bfdd408c07ae8e7efb849c4b01ac6555f318cf8409"
    end
    on_intel do
      url "https://github.com/merkhain/releases/releases/download/v0.0.9/merkhain_0.0.9_linux_amd64.tar.gz"
      sha256 "9fd24f2c8a9bfd8c248372e5c5698131a24b86ac7610a04300e96cb6d725a533"
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
