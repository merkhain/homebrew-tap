# Homebrew formula template, rendered by packaging/release into dist/merkhain.rb
# from the GoReleaser archives and SHA256SUMS. Not published anywhere: at launch
# the rendered file goes into the merkhain/homebrew-tap repository
# (docs/development/distribution.md).
class Merkhain < Formula
  desc "Durable, private, collaborative memory for coding agents"
  homepage "https://merkhain.com"
  version "0.0.6"

  on_macos do
    on_arm do
      url "https://github.com/merkhain/releases/releases/download/v0.0.6/merkhain_0.0.6_darwin_arm64.tar.gz"
      sha256 "70c48af0d3f129173b3a61b4c0256025540bedc6daf1c8f073b6f0ff1aafac33"
    end
    on_intel do
      url "https://github.com/merkhain/releases/releases/download/v0.0.6/merkhain_0.0.6_darwin_amd64.tar.gz"
      sha256 "10b493c1e1acc6018a5f71f12befd76a3529eb73bf4a608255f53a3ef9c46519"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/merkhain/releases/releases/download/v0.0.6/merkhain_0.0.6_linux_arm64.tar.gz"
      sha256 "9a61f8c6695155f3ddd6538c430c1ba09165ed74338908790209645de866c98b"
    end
    on_intel do
      url "https://github.com/merkhain/releases/releases/download/v0.0.6/merkhain_0.0.6_linux_amd64.tar.gz"
      sha256 "1c5f74d309a0495260d8500fc090a5f7f37637be932ce06238a7f07e8f1ff1bd"
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
