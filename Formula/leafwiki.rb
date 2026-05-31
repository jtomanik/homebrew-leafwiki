class Leafwiki < Formula
  desc "Fast self-hosted wiki with local MCP support"
  homepage "https://github.com/jtomanik/leafwiki"
  version "0.11.0-dev.22ea707"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.22ea707/leafwiki-0.11.0-dev.22ea707-darwin-arm64.tar.gz"
    sha256 "b3bb9894092c2d0dc68bed0b949292c15e14ea53d1168f71a4149e7304cd421d"
  else
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.22ea707/leafwiki-0.11.0-dev.22ea707-darwin-amd64.tar.gz"
    sha256 "764c35eff3c4a5f2cae84f17e5f05ef17e913eea4075c999d08dd4e508bcb1d6"
  end

  def install
    inreplace "run-mcp.sh", "leafwiki-mcp-stdio", "leafwiki-local-mcp"

    bin.install "leafwiki"
    bin.install "leafwiki-local-mcp"
    bin.install "run-mcp.sh"
  end

  test do
    assert_match "LeafWiki", shell_output("#{bin}/leafwiki --help 2>&1")
    assert_match "leafwiki-mcp-stdio bridges", shell_output("#{bin}/leafwiki-local-mcp --help 2>&1")
    assert_match "leafwiki-local-mcp", shell_output("#{bin}/run-mcp.sh --dry-run --api-key test 2>&1")
  end
end
