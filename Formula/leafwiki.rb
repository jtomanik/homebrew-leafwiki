class Leafwiki < Formula
  desc "Fast self-hosted wiki with local MCP support"
  homepage "https://github.com/jtomanik/leafwiki"
  version "0.11.0-dev.97de793"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.97de793/leafwiki-0.11.0-dev.97de793-darwin-arm64.tar.gz"
    sha256 "90422fdc861c9d06d2eed625d39600d06e9b34161170e919fa68cdf5dc9b4d23"
  else
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.97de793/leafwiki-0.11.0-dev.97de793-darwin-amd64.tar.gz"
    sha256 "494e944969fe8b2702eb0237147ee9567286d26c46dd42a63046a98dc2af131e"
  end

  def install
    bin.install "leafwiki"
    bin.install "run.sh"
  end

  test do
    assert_match "LeafWiki", shell_output("#{bin}/leafwiki --help 2>&1")
    dry_run = shell_output("#{bin}/run.sh mcp --dry-run --api-key test 2>&1")
    assert_match "--mcp=stdio", dry_run
    assert_match "--enable-workspace-sync", dry_run
    refute_match "leafwiki-local-mcp", dry_run
    refute_match "leafwiki-mcp-stdio", dry_run
  end
end
