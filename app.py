from flask import Flask, Response, stream_with_context, send_from_directory
from flask_cors import CORS
import subprocess
import os
import sys

app = Flask(__name__, static_folder='plays', static_url_path='/plays')
# Habilita CORS para todas as origens
CORS(app, origins="*", supports_credentials=True)

# Serve arquivos estáticos de cada play, se necessário
@app.route('/plays/<path:filename>')
def serve_play_static(filename):
    return send_from_directory(app.static_folder, filename)

# SSE: executa run.sh em cada play e envia saída em tempo real
@app.route('/api/play/<int:play_id>/stream')
def stream_play(play_id):
    plays_dir = os.path.join(os.getcwd(), 'plays')
    folder_pattern = f'play-{play_id:02d}'

    # Busca diretório correspondente
    dirs = [d for d in os.listdir(plays_dir) if d.startswith(folder_pattern)]
    if not dirs:
        return Response(f"data: Play {play_id} não encontrado\n\n", mimetype='text/event-stream')

    play_folder = os.path.join(plays_dir, dirs[0])
    script_path = os.path.join(play_folder, 'run.sh')

    # DEBUG: imprime o caminho do script no log do servidor
    app.logger.debug(f"Executando script: {script_path}")

    # Verifica existência do script
    if not os.path.isfile(script_path):
        return Response(f"data: Script não encontrado: {script_path}\n\n", mimetype='text/event-stream')

    def generate():
        # Executa o run.sh via bash
        proc = subprocess.Popen(
            ['bash', script_path],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True
        )
        # Stream de cada linha como SSE
        for line in proc.stdout:
            yield f"data: {line.rstrip()}\n\n"
        # Mensagem final
        yield "data: [\u2714\ufe0f] Teste finalizado com sucesso.\n\n"

    return Response(stream_with_context(generate()), mimetype='text/event-stream')

if __name__ == '__main__':
    # Permite configuração de porta via variável de ambiente
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
