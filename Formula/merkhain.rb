# Homebrew formula template, rendered by packaging/release into dist/merkhain.rb
# from the GoReleaser archives and SHA256SUMS. Not published anywhere: at launch
# the rendered file goes into the merkhain/homebrew-tap repository
# (docs/development/distribution.md).
class Merkhain < Formula
  desc "Durable, private, collaborative memory for coding agents"
  homepage "https://merkhain.com"
  version "0.0.2"

  on_macos do
    on_arm do
      url "https://github.com/merkhain/releases/releases/download/v0.0.2/merkhain_0.0.2_darwin_arm64.tar.gz"
      sha256 "5a78d16f7fe172d4b7931514bb41a3a44404b7bd5c5cf995da3eb6d829f0c5f1"
    end
    on_intel do
      url "https://github.com/merkhain/releases/releases/download/v0.0.2/merkhain_0.0.2_darwin_amd64.tar.gz"
      sha256 "7d3ad5c7c20b6a4ddac155436cdcfeddd842390099cf620afe5f173e8faae063"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/merkhain/releases/releases/download/v0.0.2/merkhain_0.0.2_linux_arm64.tar.gz"
      sha256 "13656d1f61dc382a344be7ce8dcaabdb4c1b8887470313d23fc00b20b93cb5ce"
    end
    on_intel do
      url "https://github.com/merkhain/releases/releases/download/v0.0.2/merkhain_0.0.2_linux_amd64.tar.gz"
      sha256 "c3aa8d218084727a2ca9703fdd60df591c6695f90c22a4e4c7b3c3d720dd7d6b"
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
