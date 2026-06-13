class Leafwiki < Formula
  desc "Fast self-hosted wiki with local MCP support"
  homepage "https://github.com/jtomanik/leafwiki"
  version "0.11.0-dev.20260613.e9431a9"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.20260613.e9431a9/leafwiki-0.11.0-dev.20260613.e9431a9-darwin-arm64.tar.gz"
    sha256 "269bc3e3129e3c98632de2f3fff1c3e83640c3b3892a360b9d74ad31bddfbb71"
  else
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.20260613.e9431a9/leafwiki-0.11.0-dev.20260613.e9431a9-darwin-amd64.tar.gz"
    sha256 "77f15616b2f8ae9ab8b6e7b3b77ed066f52984fe8a847b5b12128673929e486c"
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
