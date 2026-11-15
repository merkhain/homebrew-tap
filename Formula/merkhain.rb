# Homebrew formula template, rendered by packaging/release into dist/merkhain.rb
# from the GoReleaser archives and SHA256SUMS. Not published anywhere: at launch
# the rendered file goes into the merkhain/homebrew-tap repository
# (docs/development/distribution.md).
class Merkhain < Formula
  desc "Durable, private, collaborative memory for coding agents"
  homepage "https://merkhain.com"
  version "0.0.3"

  on_macos do
    on_arm do
      url "https://github.com/merkhain/releases/releases/download/v0.0.3/merkhain_0.0.3_darwin_arm64.tar.gz"
      sha256 "b8539f9e14f5932ab4e146dee9a60257b7f1728024768c8d98f9a8e1f159e2dd"
    end
    on_intel do
      url "https://github.com/merkhain/releases/releases/download/v0.0.3/merkhain_0.0.3_darwin_amd64.tar.gz"
      sha256 "53665e71945955e107d319bb3c37c4089f438c46a5f706adce1ff250c1eb4041"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/merkhain/releases/releases/download/v0.0.3/merkhain_0.0.3_linux_arm64.tar.gz"
      sha256 "8d8e621b5760fe0ed5e68f23033f15e4e1f831c119e8b471d1f6b324e039278f"
    end
    on_intel do
      url "https://github.com/merkhain/releases/releases/download/v0.0.3/merkhain_0.0.3_linux_amd64.tar.gz"
      sha256 "7006467ebeeb49219f7385110d5215e68473945fd479a057691929b8f9c4afce"
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
