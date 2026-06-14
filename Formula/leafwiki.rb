class Leafwiki < Formula
  desc "Fast self-hosted wiki with local MCP support"
  homepage "https://github.com/jtomanik/leafwiki"
  version "0.11.0-dev.20260614.4e180fd"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.20260614.4e180fd/leafwiki-0.11.0-dev.20260614.4e180fd-darwin-arm64.tar.gz"
    sha256 "11a05415cd961df7fb767edbc6a5072239dfc9206c230c8d14b2f017df946dfa"
  else
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.20260614.4e180fd/leafwiki-0.11.0-dev.20260614.4e180fd-darwin-amd64.tar.gz"
    sha256 "3820fe7ed18fd0269e1e48539bcf272ed57a87ff2015fe2d551ddceda3b966b9"
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
