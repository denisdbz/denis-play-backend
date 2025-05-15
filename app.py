from flask import Flask, Response, stream_with_context, send_from_directory
from flask_cors import CORS
import subprocess
import os

app = Flask(__name__, static_folder='plays', static_url_path='/plays')
CORS(app, origins="*", supports_credentials=True)

# Serve arquivos estáticos (index.html, run.sh, etc)
@app.route('/plays/<path:filename>')
def serve_play_static(filename):
    return send_from_directory(app.static_folder, filename)

# SSE: executa run.sh e streama saída em tempo real
@app.route('/api/play/<int:play_id>/stream')
def stream_play(play_id):
    plays_dir = os.path.join(os.getcwd(), 'plays')
    folder_prefix = f'play-{play_id:02d}'
    # encontra o nome exato da pasta (ex: play-01-nmap-recon)
    dirs = [d for d in os.listdir(plays_dir) if d.startswith(folder_prefix)]
    if not dirs:
        resp = Response(f"data: Play {play_id} não encontrado\n\n", mimetype='text/event-stream')
        resp.headers['Access-Control-Allow-Origin'] = '*'
        return resp

    play_folder = os.path.join(plays_dir, dirs[0])
    script_path = os.path.join(play_folder, 'run.sh')
    if not os.path.isfile(script_path):
        resp = Response(f"data: Script não encontrado: {script_path}\n\n", mimetype='text/event-stream')
        resp.headers['Access-Control-Allow-Origin'] = '*'
        return resp

    def generate():
        proc = subprocess.Popen(
            ['bash', script_path],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True
        )
        for line in proc.stdout:
            yield f"data: {line.rstrip()}\n\n"
        yield "data: [✔️] Teste finalizado com sucesso.\n\n"

    resp = Response(stream_with_context(generate()), mimetype='text/event-stream')
    resp.headers['Access-Control-Allow-Origin'] = '*'
    return resp

if __name__ == '__main__':
    # Para debug local
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 5000)))
