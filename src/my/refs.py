from pathlib import Path
import requests
import subprocess
import tempfile
import hashlib

def md5(fname):
    hash_md5 = hashlib.md5()
    with open(fname, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()

def sha256(fname):
    hash_sha256 = hashlib.sha256()
    with open(fname, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_sha256.update(chunk)
    return hash_sha256.hexdigest()


class Refs(object):

    def __init__(self, refs_dir: str):
        self.refs_dir = Path(refs_dir)

    def ddl_html(self, uri, path):
        # title = title.replace(" ", "_")
        # tmp_file = tempfile.NamedTemporaryFile()
        # cmd = f"monolith -Ij {uri} -o {tmp_file.name}"
        cmd = f'monolith -Ij {uri} -o {path}'
        print(cmd)
        output = subprocess.run(cmd.split(" "))
        # hash_sha256 = sha256(tmp_file.name)

    def git_annex_add(self, path):
        cmd = f'git annex add {path}'
        output = subprocess.run(cmd.split(" "))
        cmd = f'git commit -m "archive {path}"'
        output = subprocess.run(cmd.split(" "))

    def create_hardlink(self, path):
        # TODO
        # cmd = f'ln {path} {}'
        output = subprocess.run(cmd.split(" "))

    def archive(self,
                uri: str,
                idd: str,
                title: str):

        # ddl uri
        r = requests.get(uri, allow_redirects=True)
        print(r.headers.get('content-type'))


        if "text/html" in r.headers.get('content-type'):

            path = self.refs_dir / f'{idd}.html'
            self.ddl_html(uri, path)

        self.git_annex_add(path)
        # self.create_hardlink(path, title)
