# money_note

個人の資産・支出を一元管理する Flutter 製の家計簿アプリです。
手持ち現金・銀行口座・電子マネーの残高管理から、支出の記録・分析まで幅広く対応しています。

---

## 主な機能

### 資産管理
- **手持ち現金** — 1円〜10,000円の券種別に枚数を入力し、現金残高を管理
- **銀行口座** — 複数の銀行口座の残高を登録・管理・調整
- **電子マネー** — 複数の電子マネーの残高を登録・管理
- **収入** — 収入の記録と管理
- **総資産グラフ** — 現金・銀行・電子マネーを合算した総資産の推移を可視化

### 支出管理
- **支出記録** — 日時・場所・項目・金額を紐付けて記録
- **支出項目** — カスタム支出カテゴリの作成・編集（カラー設定・ドラッグ＆ドロップ並び替え対応）
- **月別・年別集計** — 月次／年次の支出サマリーをグラフ・一覧で表示
- **同日比較** — 過去の同月同日の支出と比較表示
- **日次現金確認** — 日付ごとの現金残高の確認と修正

### データ管理
- **CSVエクスポート** — 支出データを CSV 形式でエクスポート
- **データダウンロード** — 記録データのダウンロード・共有
- **ログインアカウント管理** — ローカルアカウントによる認証

---

## 技術スタック

| カテゴリ | 技術 |
|---|---|
| フレームワーク | [Flutter](https://flutter.dev/) (Dart SDK >=3.2.0) |
| 状態管理 | [Riverpod](https://riverpod.dev/) (hooks_riverpod / riverpod_annotation) |
| ローカルDB | [Isar](https://isar.dev/) v3 |
| コード生成 | freezed / json_serializable / riverpod_generator / build_runner |
| グラフ | [fl_chart](https://pub.dev/packages/fl_chart) |
| フォント | [KiwiMaru](https://fonts.google.com/specimen/Kiwi+Maru) / Google Fonts |
| その他 | fl_chart, drag_and_drop_lists, flutter_colorpicker, share_plus, file_picker, csv |

---

## 対応プラットフォーム

- Android
- iOS
- macOS
- Windows
- Linux

---

## データモデル (Isar Collections)

| コレクション | 概要 |
|---|---|
| `Money` | 日付ごとの手持ち現金（券種別枚数） |
| `BankName` | 銀行口座名 |
| `BankPrice` | 銀行口座残高 |
| `EmoneyName` | 電子マネー名 |
| `Income` | 収入記録 |
| `SpendTimePlace` | 支出記録（日時・場所・金額） |
| `SpendItem` | 支出項目（カテゴリ） |
| `Config` | アプリ設定 |
| `LoginAccount` | ログインアカウント情報 |

---

## プロジェクト構成

```
lib/
├── main.dart                  # エントリーポイント・Isar初期化
├── collections/               # Isarコレクション定義
├── controllers/               # Riverpodコントローラー
├── model/                     # データモデル
├── repository/                # データアクセス層
├── screens/
│   ├── login_screen.dart      # ログイン画面
│   ├── signup_screen.dart     # サインアップ画面
│   ├── home_screen.dart       # ホーム画面
│   └── components/            # ダイアログ・UIコンポーネント
├── enums/                     # 列挙型
├── extensions/                # 拡張メソッド
└── utilities/                 # ユーティリティ
```

---

## セットアップ

### 前提条件

- Flutter SDK 3.2.0 以上
- Dart SDK 3.2.0 以上

### インストール手順

```bash
# リポジトリをクローン
git clone https://github.com/toyotarou/app-moneynote3-3.git
cd app-moneynote3-3

# 依存パッケージをインストール
flutter pub get

# コード生成（Isar / Riverpod / Freezed）
dart run build_runner build --delete-conflicting-outputs

# アプリを実行
flutter run
```

---

## ライセンス

このプロジェクトはプライベートリポジトリです (`publish_to: 'none'`)。
