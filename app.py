from flask import Flask, Response, stream_with_context, send_from_directory, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask import request

db = SQLAlchemy()

class Formulario(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(120), nullable=False)
    mensagem = db.Column(db.Text, nullable=False)
from flask_cors import CORS
import subprocess
import os
import requests

app = Flask(__name__, static_folder='plays', static_url_path='/plays')
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///cadastros.db'
db.init_app(app)
CORS(app, origins="*", supports_credentials=True)

# Serve arquivos estáticos de cada play
@app.route('/plays/<path:filename>')
def serve_play_static(filename):
    return send_from_directory(app.static_folder, filename)

# SSE: executa run.sh e streama saída em tempo real
@app.route('/api/play/<int:play_id>/stream')
def stream_play(play_id):
    plays_dir = os.path.join(os.getcwd(), 'plays')
    folder_pattern = f'play-{play_id:02d}'
    dirs = [d for d in os.listdir(plays_dir) if d.startswith(folder_pattern)]
    if not dirs:
        return Response(f"data: Play {play_id} não encontrado\n\n", mimetype='text/event-stream')

    play_folder = os.path.join(plays_dir, dirs[0])
    script_path = os.path.join(play_folder, 'run.sh')
    if not os.path.isfile(script_path):
        return Response(f"data: Script não encontrado: {script_path}\n\n", mimetype='text/event-stream')

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

    return Response(stream_with_context(generate()), mimetype='text/event-stream')

# Novo endpoint proxy para Notícias, evitando CORS
NEWS_API_KEY = 'KTeKQv1H4PHbtVhF_fwXVLvA178RVJ6z13A_KqgZuYuxLGp3'

@app.route('/api/news')
def api_news():
    resp = requests.get(
        'https://api.currentsapi.services/v1/latest-news',
        params={'apiKey': NEWS_API_KEY}
    )
    return jsonify(resp.json())

@app.route('/api/cadastro', methods=['POST'])
def cadastro():
    data = request.json
    novo = Formulario(nome=data['nome'], email=data['email'], mensagem=data['mensagem'])
    db.session.add(novo)
    db.session.commit()
    return jsonify({'status': 'sucesso'})

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)


# Após a definição do model
with app.app_context():
    db.create_all()
