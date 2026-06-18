class Leafwiki < Formula
  desc "Fast self-hosted wiki with local MCP support"
  homepage "https://github.com/jtomanik/leafwiki"
  version "0.11.0-dev.20260618.8b8facf"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.20260618.8b8facf/leafwiki-0.11.0-dev.20260618.8b8facf-darwin-arm64.tar.gz"
    sha256 "d1472661c5229c782b7b6b1551be4a75e4e04e1461f3d3269ff401527b664ac9"
  else
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.11.0-dev.20260618.8b8facf/leafwiki-0.11.0-dev.20260618.8b8facf-darwin-amd64.tar.gz"
    sha256 "0fc29142808461693602e254c26c189187f7793c3c323637c4885d10884c1b7f"
  end

  def install
    bin.install "leafwiki"
    bin.install "run.sh"
    pkgshare.install "config/leafwiki.service.example.yml"

    (libexec/"leafwiki-service").write <<~BASH
      #!/usr/bin/env bash
      set -euo pipefail

      service_dir="${HOME}/.leafwiki"
      service_config="${service_dir}/leafwiki.yml"
      if [[ ! -e "${service_config}" ]]; then
        mkdir -p "${service_dir}"
        chmod 700 "${service_dir}"
        install -m 600 "#{opt_pkgshare}/leafwiki.service.example.yml" "${service_config}"
      fi

      if [[ "${LEAFWIKI_SERVICE_BOOTSTRAP_ONLY:-0}" == "1" ]]; then
        exit 0
      fi

      exec "#{opt_bin}/leafwiki" daemon
    BASH
    chmod 0755, libexec/"leafwiki-service"
  end

  service do
    run opt_libexec/"leafwiki-service"
    keep_alive true
    working_dir var
    log_path var/"log/leafwiki/leafwiki.stdout.log"
    error_log_path var/"log/leafwiki/leafwiki.stderr.log"
  end

  def caveats
    <<~EOS
      LeafWiki service config is stored at:
        ~/.leafwiki/leafwiki.yml

      `brew services start jtomanik/leafwiki/leafwiki` creates that file if it
      is missing, using:
        #{pkgshare}/leafwiki.service.example.yml

      The default service config is local-only: it binds to 127.0.0.1, disables auth,
      and enables local HTTP MCP. Edit ~/.leafwiki/leafwiki.yml before exposing
      LeafWiki beyond loopback.

      To create the config before starting the service:
        mkdir -p ~/.leafwiki
        chmod 700 ~/.leafwiki
        install -m 600 #{opt_pkgshare}/leafwiki.service.example.yml ~/.leafwiki/leafwiki.yml

      To reload service config changes:
        brew services restart jtomanik/leafwiki/leafwiki
    EOS
  end

  test do
    assert_match "LeafWiki", shell_output("#{bin}/leafwiki --help 2>&1")
    assert_match "leafwiki daemon", shell_output("#{bin}/leafwiki daemon --help 2>&1")
    assert_match "disable-auth: true", (pkgshare/"leafwiki.service.example.yml").read
    service_home = testpath/"service-home"
    with_env(HOME: service_home.to_s, LEAFWIKI_SERVICE_BOOTSTRAP_ONLY: "1") do
      system libexec/"leafwiki-service"
    end
    assert_match "disable-auth: true", (service_home/".leafwiki/leafwiki.yml").read
    dry_run = shell_output("#{bin}/run.sh mcp --dry-run --api-key test 2>&1")
    assert_match "--mcp=stdio", dry_run
    assert_match "--enable-workspace-sync", dry_run
    refute_match "leafwiki-local-mcp", dry_run
    refute_match "leafwiki-mcp-stdio", dry_run
  end
end
