# Homebrew formula template, rendered by packaging/release into dist/merkhain.rb
# from the GoReleaser archives and SHA256SUMS. Not published anywhere: at launch
# the rendered file goes into the merkhain/homebrew-tap repository
# (docs/development/distribution.md).
class Merkhain < Formula
  desc "Durable, private, collaborative memory for coding agents"
  homepage "https://merkhain.com"
  version "0.0.1"

  on_macos do
    on_arm do
      url "https://github.com/merkhain/releases/releases/download/v0.0.1/merkhain_0.0.1_darwin_arm64.tar.gz"
      sha256 "58a62c0f31aed8dd18b73285c7983cb06d7f64359f5cf16952600ccaf7843620"
    end
    on_intel do
      url "https://github.com/merkhain/releases/releases/download/v0.0.1/merkhain_0.0.1_darwin_amd64.tar.gz"
      sha256 "732dc26c42e207657fb0d3fd56394e9f8903b3c898d333fce51a0f69933b1f1f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/merkhain/releases/releases/download/v0.0.1/merkhain_0.0.1_linux_arm64.tar.gz"
      sha256 "703ca7b5a20bb7f223f81fbd0269df762767545663dbe3f4e313b905ef906974"
    end
    on_intel do
      url "https://github.com/merkhain/releases/releases/download/v0.0.1/merkhain_0.0.1_linux_amd64.tar.gz"
      sha256 "654ec49d99b2eda6ceb4d438a0e5f2f31bcc912b42cf1efe31740cc72e47b7ff"
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
