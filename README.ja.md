# claunch 🧠🚀

![claunch](claunch-banner.png)

[![en](https://img.shields.io/badge/lang-en-blue.svg)](README.md)

> Claude CLI を複数プロジェクトで効率的に管理する軽量セッションマネージャー

`claunch` は、各プロジェクトごとに Claude のセッションを切り分け、オプションで tmux サポートを提供する開発支援ツールです。

- 🧠 プロジェクトごとの Claude セッション管理（自動 resume）
- ⚡ デフォルトで軽量な直接実行
- 🧰 永続セッションのためのオプションの tmux サポート
- 💻 macOS / Debian 系 Linux 対応
- 🔐 `--dangerously-skip-permissions` フラグを自動付与
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

## ⚠️ セキュリティに関する注意

`claunch` は Claude CLI を `--dangerously-skip-permissions` フラグ付きで自動実行します。これは以下を意味します：

- **Claude がファイルシステムに完全アクセス権限を持つ**（許可を求めずに）
- **すべてのファイル読み書き操作が即座に実行される**（確認なしで）
- **信頼できるプロジェクトディレクトリでのみ使用してください**
- **本番環境や機密データでの使用は推奨されません**

このフラグは開発の利便性のために含まれており、Claude が許可プロンプトなしで効率的に作業できるようにしています。ただし、このツールを使用する際のセキュリティへの影響を認識してください。

---

## 📖 使い方

### 1. 新しい Claude セッションを開始

プロジェクトディレクトリに移動して実行:

```bash
claunch        # 直接 Claude セッション（デフォルト）
claunch --tmux # 永続セッションのために tmux を使用
```

初回実行時:
- tmux が自動的にインストールされます（tmuxモードのみ、未インストールの場合）
- 新しい Claude セッションが開始されます
- 保存すべきセッション ID が表示されます

#### 直接モード vs tmuxモード

- **直接モード**（デフォルト）: 軽量、tmux依存なし、直接Claude対話
- **tmuxモード**（`--tmux`）: 永続セッション、バックグラウンド実行、スクロール履歴

### 2. セッション ID を保存

Claude 起動時に `sess-xxxxxxxx` のようなセッション ID が表示されます。これを保存:

```bash
echo "sess-xxxxxxxx" > ~/.claude_session_プロジェクト名
```

### 3. 既存セッションを再開

同じプロジェクトディレクトリで再度 `claunch`（または `claunch --tmux`）を実行するだけです。自動的に:
- 保存されたセッション ID を検出
- 前回の Claude 会話を再開
- すべてのコンテキストを維持

### 4. 追加コマンド

```bash
claunch list     # すべてのアクティブセッション一覧
claunch clean    # 孤立したセッションファイルをクリーンアップ
claunch --help   # ヘルプとオプションを表示
```

---

## 🛠 機能

### tmux 自動インストール（--tmux 使用時）

`claunch` は `--tmux` オプション使用時に tmux が存在しない場合、自動的に検出してインストール:

- **macOS**: Homebrew を使用（`brew install tmux`）
- **Debian/Ubuntu**: apt を使用（`sudo apt install tmux`）
- **その他のシステム**: 手動インストール手順を提供

### プロジェクトベースのセッション管理

各プロジェクトは独自の:
- `~/.claude_session_プロジェクト名` のセッション ID ファイル
- 隔離された Claude 会話コンテキスト
- オプションで `claude-プロジェクト名` という名前の tmux セッション（`--tmux` 使用時）

### 永続的セッション（tmuxモード）

`claunch --tmux` で:
- ターミナルを閉じてもセッションは維持
- いつでも `claunch --tmux` で再接続可能
- 複数のプロジェクトをバックグラウンドで同時実行可能

### tmux 操作ガイド

`claunch --tmux` 経由で Claude を実行すると、tmux セッション内にいます。重要なコマンド：

- **セッションからデタッチ**: `Ctrl+B` を押してから `D` を押す
  - Claude をバックグラウンドで実行したまま
  - 通常のターミナルに戻る
- **上下にスクロール**: `Ctrl+B` を押してから `[` でコピーモードに入る
  - 矢印キーまたは Page Up/Down でスクロール
  - `q` を押してコピーモードを終了
- **テキストをコピー**: コピーモード（`Ctrl+B` → `[`）で：
  - 開始位置にカーソルを移動
  - `Space` を押して選択開始
  - 終了位置まで移動
  - `Enter` を押してコピー
- **テキストを貼り付け**: `Ctrl+B` を押してから `]` を押す
- **セッションを終了**: `Ctrl+B` を押してから `&`（注意して使用）

> **ヒント**: `tmux attach -t claude-プロジェクト名` で手動でセッションにアタッチすることもできます

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

## 🧪 開発

`claunch` は単一の Bash スクリプトです。よく使うタスクは `Makefile` にまとめてあります:

```bash
make lint     # shellcheck でシェルスクリプトを静的解析
make test     # スモークテストを実行
make install  # claunch を $HOME/bin にインストール
make help     # 利用可能なターゲット一覧を表示
```

- **Lint** は [shellcheck](https://www.shellcheck.net/) を使用します。`brew install shellcheck`（macOS）または `apt install shellcheck`（Debian/Ubuntu）でインストールできます。
- **テスト** は `tests/test_claunch.sh` にあり、隔離された `HOME` と `PATH` 上のダミー `claude` を使って実行されるため、実際の環境には一切影響しません。

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