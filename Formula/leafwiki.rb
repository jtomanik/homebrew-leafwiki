class Leafwiki < Formula
  desc "Fast self-hosted wiki with local MCP support"
  homepage "https://github.com/jtomanik/leafwiki"
  version "0.11.0-dev.7e38b39"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.7e38b39/leafwiki-0.11.0-dev.7e38b39-darwin-arm64.tar.gz"
    sha256 "aa346040c4d0c0c0fa0663f7ffec9e72bd1156f9c33760e8627c0985d067b4e8"
  else
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.7e38b39/leafwiki-0.11.0-dev.7e38b39-darwin-amd64.tar.gz"
    sha256 "63682faf9be3cf196ecac4d42f5da454949e43213520c3b70a6059b684486237"
  end

  def install
    bin.install "leafwiki"
    bin.install "run-mcp.sh"
  end

  test do
    assert_match "LeafWiki", shell_output("#{bin}/leafwiki --help 2>&1")
    dry_run = shell_output("#{bin}/run-mcp.sh --dry-run --api-key test 2>&1")
    assert_match "--mcp=stdio", dry_run
    refute_match "leafwiki-local-mcp", dry_run
  end
end
