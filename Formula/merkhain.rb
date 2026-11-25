# Homebrew formula template, rendered by packaging/release into dist/merkhain.rb
# from the GoReleaser archives and SHA256SUMS. Not published anywhere: at launch
# the rendered file goes into the merkhain/homebrew-tap repository
# (docs/development/distribution.md).
class Merkhain < Formula
  desc "Durable, private, collaborative memory for coding agents"
  homepage "https://merkhain.com"
  version "0.0.7"

  on_macos do
    on_arm do
      url "https://github.com/merkhain/releases/releases/download/v0.0.7/merkhain_0.0.7_darwin_arm64.tar.gz"
      sha256 "120d0b23615e97f2143a7fc23b4729d7379c81f489ea4eca7b657bf2be0531d9"
    end
    on_intel do
      url "https://github.com/merkhain/releases/releases/download/v0.0.7/merkhain_0.0.7_darwin_amd64.tar.gz"
      sha256 "57e74100684fba6950ecbec21adddcaa35b61b239b77bad9e38f6f728de12e92"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/merkhain/releases/releases/download/v0.0.7/merkhain_0.0.7_linux_arm64.tar.gz"
      sha256 "3d25a91eb07654ed73367016bcc85d126c56f8d2adee703da7a15b6742e9c61d"
    end
    on_intel do
      url "https://github.com/merkhain/releases/releases/download/v0.0.7/merkhain_0.0.7_linux_amd64.tar.gz"
      sha256 "20caf3cf09d4cff1bf53f68fa89fbf4166504c535b7868ae52cded13eb14bad4"
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
