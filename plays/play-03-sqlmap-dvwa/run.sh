 #!/usr/bin/env bash
 set -euo pipefail

 TARGET_HOST="${DVWA_HOST:-web-dvwa-production.up.railway.app}"
 SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
 COOKIE_FILE="$SCRIPT_DIR/cookies.txt"

echo "[*] Autenticando no DVWA em https://$TARGET_HOST/login.php..."
-# 1. Login e captura cookies (inclui redirect)
-curl -ks -c "$COOKIE_FILE" -L \
-  -d "username=admin&password=password&Login=Login" \
-  "https://$TARGET_HOST/login.php" > /dev/null
echo "[*] Iniciando sessão em https://$TARGET_HOST/login.php (gera PHPSESSID)…"
+# 1. GET inicial para pegar PHPSESSID
+curl -ks -c "$COOKIE_FILE" \
+  "https://$TARGET_HOST/login.php" > /dev/null
+
echo "[*] Autenticando no DVWA (POST login)…"
+# 2. POST de login, anexando e atualizando o cookie-jar
+curl -ks -b "$COOKIE_FILE" -c "$COOKIE_FILE" -L \
+  -d "username=admin&password=password&Login=Login" \
+  "https://$TARGET_HOST/login.php" > /dev/null

 echo "[*] Definindo segurança para LOW..."
 curl -ks -b "$COOKIE_FILE" -L \
   "https://$TARGET_HOST/security.php?security=low" > /dev/null
