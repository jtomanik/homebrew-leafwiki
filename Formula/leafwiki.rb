class Leafwiki < Formula
  desc "Fast self-hosted wiki with local MCP support"
  homepage "https://github.com/jtomanik/leafwiki"
  version "0.11.0-dev.20260615.2bdd2e0"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.20260615.2bdd2e0/leafwiki-0.11.0-dev.20260615.2bdd2e0-darwin-arm64.tar.gz"
    sha256 "cb265a82db6bc74e3da039a2cedb7bf7d897acba897e4ac3a2d8d047eb11c644"
  else
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.20260615.2bdd2e0/leafwiki-0.11.0-dev.20260615.2bdd2e0-darwin-amd64.tar.gz"
    sha256 "818d3b4e14af639be51a2005ac0133d86786ec2acd0ca517913a0fa7bc9e9b6e"
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
