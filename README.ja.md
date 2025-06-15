# claunch 🧠🚀

[![en](https://img.shields.io/badge/lang-en-blue.svg)](README.md)

> Claude CLI を複数プロジェクトで効率的に扱うための tmux ラッパーツール

`claunch` は、各プロジェクトごとに Claude のセッションを切り分け、tmux 上で永続的に対話できる開発支援ツールです。

- 🧠 プロジェクトごとの Claude セッション管理（自動 resume）
- 🧰 tmux が未インストールでも OS に応じて自動インストール
- 💻 macOS / Debian 系 Linux 対応
- 🔐 `--dangerously-skip-permissions` を自動付与
- 🔄 セッションIDの保存・再利用が簡単

---

## 🚀 インストール（ワンライナー）

```bash
bash <(curl -s https://raw.githubusercontent.com/0xkaz/claunch/main/install.sh)
```

または wget を使用:

```bash
bash <(wget -qO- https://raw.githubusercontent.com/0xkaz/claunch/main/install.sh)
```

> **注意**: `claunch` は `$HOME/bin/claunch` にインストールされます。`$HOME/bin` が PATH に含まれていることを確認してください。

---

## 📖 使い方

### 1. 新しい Claude セッションを開始

プロジェクトディレクトリに移動して実行:

```bash
claunch
```

初回実行時:
- tmux が自動的にインストールされます（未インストールの場合）
- 新しい Claude セッションが開始されます
- 保存すべきセッション ID が表示されます

### 2. セッション ID を保存

Claude 起動時に `sess-xxxxxxxx` のようなセッション ID が表示されます。これを保存:

```bash
echo "sess-xxxxxxxx" > ~/.claude_session_プロジェクト名
```

### 3. 既存セッションを再開

同じプロジェクトディレクトリで再度 `claunch` を実行するだけです。自動的に:
- 保存されたセッション ID を検出
- 前回の Claude 会話を再開
- すべてのコンテキストを維持

---

## 🛠 機能

### tmux 自動インストール

`claunch` は tmux が存在しない場合、自動的に検出してインストール:

- **macOS**: Homebrew を使用（`brew install tmux`）
- **Debian/Ubuntu**: apt を使用（`sudo apt install tmux`）
- **その他のシステム**: 手動インストール手順を提供

### プロジェクトベースのセッション管理

各プロジェクトは独自の:
- `claude-プロジェクト名` という名前の tmux セッション
- `~/.claude_session_プロジェクト名` のセッション ID ファイル
- 隔離された Claude 会話コンテキスト

### 永続的セッション

- ターミナルを閉じてもセッションは維持
- いつでも `claunch` で再接続可能
- 複数のプロジェクトを同時に実行可能

---

## 📝 必要要件

- Claude CLI（`claude` コマンド）
- tmux（未インストールの場合は自動インストール）
- macOS または Debian 系 Linux
- インストール用の curl または wget

---

## 🤔 FAQ

### なぜ claunch を使うのか？

- **プロジェクト分離**: プロジェクトごとに Claude の会話を分離
- **セッション永続性**: ターミナルを閉じてもコンテキストを失わない
- **自動セットアップ**: 手動での tmux 設定不要
- **マルチタスク**: 複数のプロジェクトを同時に作業可能

### プロジェクト間の切り替え方法は？

別のプロジェクトディレクトリに `cd` して `claunch` を実行するだけです。各プロジェクトは独自のセッションを維持します。

### セッション ID はどこに保存される？

セッション ID はホームディレクトリに `.claude_session_プロジェクト名` ファイルとして保存されます。

### tmux セッションに手動でアタッチできる？

はい！セッションは `claude-プロジェクト名` という名前なので、以下のようにできます:

```bash
tmux attach -t claude-myproject
```

---

## 🐛 トラブルシューティング

### "tmux not found" エラー

スクリプトが tmux を自動インストールするはずです。失敗した場合:
- **macOS**: まず Homebrew をインストール https://brew.sh
- **Linux**: sudo 権限があることを確認
- **その他**: tmux を手動でインストール https://github.com/tmux/tmux

### セッション ID が見つからない

1. セッション ID を正しく保存したか確認
2. ファイルの存在を確認: `ls ~/.claude_session_*`
3. セッション ID の形式を確認: `sess-xxxxxxxx`

### セッションを再開できない

Claude がセッションを再開できない場合:
1. セッションが期限切れの可能性
2. 新しいセッションを開始して新しい ID を保存
3. Claude のドキュメントでセッション制限を確認

---

## 📄 ライセンス

MIT ライセンス - 自由に使用・改変してください！

---

## 🤝 貢献

プルリクエスト歓迎！以下の手順でお願いします:
1. リポジトリをフォーク
2. フィーチャーブランチを作成
3. 変更をコミット
4. ブランチにプッシュ
5. プルリクエストを開く

---

Claude コミュニティのために ❤️ を込めて作成