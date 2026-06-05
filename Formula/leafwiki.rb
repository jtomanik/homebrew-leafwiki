class Leafwiki < Formula
  desc "Fast self-hosted wiki with local MCP support"
  homepage "https://github.com/jtomanik/leafwiki"
  version "0.11.0-dev.10947c1"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.10947c1/leafwiki-0.11.0-dev.10947c1-darwin-arm64.tar.gz"
    sha256 "0f589595a45ef2b124c54a638bc83beba668cc84abda114c56bfd4cc260300ee"
  else
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.10947c1/leafwiki-0.11.0-dev.10947c1-darwin-amd64.tar.gz"
    sha256 "2d2a779fb882f4a2daff03cfcadb7d17af7cca3d3fa7e68dc4543839db9ee2b8"
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
