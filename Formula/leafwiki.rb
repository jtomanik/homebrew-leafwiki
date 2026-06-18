class Leafwiki < Formula
  desc "Fast self-hosted wiki with local MCP support"
  homepage "https://github.com/jtomanik/leafwiki"
  version "0.12.0-dev.20260618.a1fdb1b"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.12.0-dev.20260618.a1fdb1b/leafwiki-0.12.0-dev.20260618.a1fdb1b-darwin-arm64.tar.gz"
    sha256 "e57e9c207d16cc0dc6fc6b60329f603610844b6b722b43e254418c4dea66aa73"
  else
    url "https://github.com/jtomanik/leafwiki/releases/download/homebrew-v0.12.0-dev.20260618.a1fdb1b/leafwiki-0.12.0-dev.20260618.a1fdb1b-darwin-amd64.tar.gz"
    sha256 "be1e456ff48ead35f9ca0d2975e5539585fd6f0e9394d9b58f377a123b6ac9cc"
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
      Homebrew installs or upgrades LeafWiki, but it does not automatically start
      or restart the background service. After installing or upgrading, run:
        brew services restart jtomanik/leafwiki/leafwiki

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
