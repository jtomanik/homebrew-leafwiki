class Leafwiki < Formula
  desc "Fast self-hosted wiki with local MCP support"
  homepage "https://github.com/jtomanik/leafwiki"
  version "0.11.0-dev.20260615.9c372c8"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.20260615.9c372c8/leafwiki-0.11.0-dev.20260615.9c372c8-darwin-arm64.tar.gz"
    sha256 "17722b61c349049afc7514866f735259fa767400defd3d26fbe8a7d407b37e46"
  else
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.20260615.9c372c8/leafwiki-0.11.0-dev.20260615.9c372c8-darwin-amd64.tar.gz"
    sha256 "036da7359b1a0bb26971b6a3c80f68f7ec0bbb54a5be1bba5c53b8a4fb883364"
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
