# Homebrew formula template, rendered by packaging/release into dist/merkhain.rb
# from the GoReleaser archives and SHA256SUMS. Not published anywhere: at launch
# the rendered file goes into the merkhain/homebrew-tap repository
# (docs/development/distribution.md).
class Merkhain < Formula
  desc "Durable, private, collaborative memory for coding agents"
  homepage "https://merkhain.com"
  version "0.0.5"

  on_macos do
    on_arm do
      url "https://github.com/merkhain/releases/releases/download/v0.0.5/merkhain_0.0.5_darwin_arm64.tar.gz"
      sha256 "1957401d7ed4eddfbb51da0da55fdc86f082e02674819b29dfaff2788ee0ecae"
    end
    on_intel do
      url "https://github.com/merkhain/releases/releases/download/v0.0.5/merkhain_0.0.5_darwin_amd64.tar.gz"
      sha256 "557bde2bf023da038805704a52979a75af7928fab4323b6d4a32c6f875c49178"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/merkhain/releases/releases/download/v0.0.5/merkhain_0.0.5_linux_arm64.tar.gz"
      sha256 "adad65f0183487f153a1744b00071fad0e11849715930f962dbf76973304856a"
    end
    on_intel do
      url "https://github.com/merkhain/releases/releases/download/v0.0.5/merkhain_0.0.5_linux_amd64.tar.gz"
      sha256 "28355c28ef8a95f1c636dac772edfe657359fbe5f77041e2b28f12638bcf633b"
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
