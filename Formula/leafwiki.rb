class Leafwiki < Formula
  desc "Fast self-hosted wiki with local MCP support"
  homepage "https://github.com/jtomanik/leafwiki"
  version "0.11.0-dev.20260609.97de793"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.20260609.97de793/leafwiki-0.11.0-dev.20260609.97de793-darwin-arm64.tar.gz"
    sha256 "14a5534a80c3ed7aedc5fe61fe915bdb4f995f5fea08bb198eb90870035692c2"
  else
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.20260609.97de793/leafwiki-0.11.0-dev.20260609.97de793-darwin-amd64.tar.gz"
    sha256 "5736d10c3b10738c8ae5871dc9c3c3276aae668e37becd913e036dfe18b062cb"
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
