# Scripts

Typst Starter 用の補助スクリプトです。

---

## スクリプト一覧

| スクリプト | 説明 |
|---|---|
| `install-package.ps1` | Starter Package をローカルにインストールする |

---

## install-package.ps1

Starter Package（`package/starter/1.0.0/`）を Typst のローカルパッケージディレクトリにコピーします。

### 実行方法

```powershell
powershell -ExecutionPolicy Bypass -File scripts\install-package.ps1
```

### 動作

1. `package/starter/1.0.0/` の全ファイルを
2. `%APPDATA%\typst\packages\local\starter\1.0.0\` にコピーします

### インストール先

```
C:\Users\<ユーザー名>\AppData\Roaming\typst\packages\local\starter\1.0.0\
```

---

## 対応 OS

Version 1.0.0 では **Windows（PowerShell）** のみ対応しています。

Linux / macOS 対応は将来バージョンで予定しています。

---

## 注意事項

- スクリプトの実行には PowerShell が必要です
- `ExecutionPolicy` を `Bypass` に設定して実行してください
- Package のソースコードを編集した場合は、再度スクリプトを実行してインストール内容を更新してください
