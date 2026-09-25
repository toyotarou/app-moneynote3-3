import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../collections/bank_name.dart';
import '../collections/bank_price.dart';
import '../collections/config.dart';
import '../collections/emoney_name.dart';
import '../collections/money.dart';
import '../collections/spend_item.dart';
import '../collections/spend_time_place.dart';
import '../controllers/controllers_mixin.dart';
import '../extensions/extensions.dart';
import '../repository/bank_names_repository.dart';
import '../repository/bank_prices_repository.dart';
import '../repository/configs_repository.dart';
import '../repository/emoney_names_repository.dart';
import '../repository/moneys_repository.dart';
import '../repository/spend_items_repository.dart';
import '../repository/spend_time_places_repository.dart';

import '../utilities/functions.dart';
import '../utilities/utilities.dart';
import 'components/___dummy_data_input_alert.dart';
import 'components/all_total_money_graph_alert.dart';
import 'components/bank_price_adjust_alert.dart';
import 'components/config_setting_alert.dart';
import 'components/csv_data/data_export_alert.dart';
import 'components/csv_data/data_import_alert.dart';
import 'components/daily_money_display_alert.dart';
import 'components/date_money_repair_alert.dart';
import 'components/deposit_tab_alert.dart';
import 'components/income_input_alert.dart';
import 'components/login_account_display_alert.dart';
import 'components/money_list_alert.dart';
import 'components/money_score_list_alert.dart';
import 'components/parts/back_ground_image.dart';
import 'components/parts/custom_shape_clipper.dart';
import 'components/parts/menu_head_icon.dart';
import 'components/parts/money_dialog.dart';
import 'components/same_day_spend_price_list_alert.dart';
import 'components/spend_item_history_alert.dart';
import 'components/spend_item_input_alert.dart';
import 'components/spend_item_re_input_alert.dart';
import 'components/spend_monthly_list_alert.dart';
import 'components/spend_time_place_delete_alert.dart';
import 'components/spend_yearly_block_alert.dart';
import 'components/table_data_delete_alert.dart';
import 'login_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key, this.baseYm, required this.isar});

  String? baseYm;
  final Isar isar;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with ControllersMixin<HomeScreen>, WidgetsBindingObserver {
  DateTime _calendarMonthFirst = DateTime.now();
  final List<String> _youbiList = <String>[
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  List<String> _calendarDays = <String>[];

  Map<String, String> _holidayMap = <String, String>{};

  final Utility _utility = Utility();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Money>? moneyList = <Money>[];

  Map<String, Money> moneyMap = <String, Money>{};

  Map<String, int> dateCurrencySumMap = <String, int>{};

  List<BankPrice>? bankPriceList = <BankPrice>[];

  List<SpendTimePlace>? allSpendTimePlaceList = <SpendTimePlace>[];
  List<SpendTimePlace>? thisMonthSpendTimePlaceList = <SpendTimePlace>[];
  List<SpendTimePlace>? prevMonthSpendTimePlaceList = <SpendTimePlace>[];

  Map<String, List<SpendTimePlace>> spendTimePlaceCountMap = <String, List<SpendTimePlace>>{};
  List<SpendTimePlace> spendTypeBlankSpendTimePlaceList = <SpendTimePlace>[];

  Map<String, int> monthlySpendTimePlaceSumMap = <String, int>{};

  Map<String, Map<String, int>> bankPricePadMap = <String, Map<String, int>>{};
  Map<String, int> bankPriceTotalPadMap = <String, int>{};

  List<BankName>? bankNameList = <BankName>[];
  List<EmoneyName>? emoneyNameList = <EmoneyName>[];

  List<Deposit> depoNameList = <Deposit>[];

  List<SpendItem>? _spendItemList = <SpendItem>[];

  List<String> monthFirstDateList = <String>[];

  Map<String, int> monthlySpendMap = <String, int>{};

  List<String> buttonLabelTextList = <String>[];

  Map<String, String> configMap = <String, String>{};

  late final List<String> _ymList;
  TabController? _tabController;

  late final IsarChangeWatcher _isarChangeWatcher;

  /// 読み込み済みの年月（表示月が変わったら読み直す）
  String? _loadedYearMonth;

  bool _loading = false;

  bool _reloadRequested = false;

  ///
  @override
  void initState() {
    super.initState();
    _ymList = _makeYmList();

    WidgetsBinding.instance.addObserver(this);

    // 以前は build のたびに全テーブルを読み直し → setState → build … を繰り返していた（画面表示中ずっと全件読み込みが走っていた）。
    // DB に変更があったとき（どの画面から書き込まれても）だけ読み直す
    _isarChangeWatcher = IsarChangeWatcher(
      streams: <Stream<void>>[
        widget.isar.moneys.watchLazy(),
        widget.isar.bankPrices.watchLazy(),
        widget.isar.spendTimePlaces.watchLazy(),
        widget.isar.bankNames.watchLazy(),
        widget.isar.emoneyNames.watchLazy(),
        widget.isar.spendItems.watchLazy(),
        widget.isar.configs.watchLazy(),
      ],
      onChanged: _loadAll,
    );
  }

  ///
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _isarChangeWatcher.dispose();
    _tabController?.removeListener(_onTabChanged);
    super.dispose();
  }

  ///
  List<String> _makeYmList() {
    final DateTime start = DateTime(2024);
    final DateTime now = DateTime.now();
    final List<String> list = <String>[];
    DateTime cursor = start;
    while (!cursor.isAfter(DateTime(now.year, now.month))) {
      list.add(cursor.yyyymm);
      cursor = DateTime(cursor.year, cursor.month + 1);
    }
    return list;
  }

  ///
  int _getInitialTabIndex() {
    final String initial = widget.baseYm ?? DateTime.now().yyyymm;
    final int idx = _ymList.indexOf(initial);
    return idx >= 0 ? idx : _ymList.length - 1;
  }

  ///
  void _onTabChanged() {
    if (_tabController != null && !_tabController!.indexIsChanging) {
      calendarNotifier.setCalendarYearMonth(baseYm: _ymList[_tabController!.index]);
    }
  }

  ///
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 銀行残高は「今日」までの日割りで作るため、日付をまたいで復帰した場合に備えて読み直す
    // （以前は常時読み込みループで結果的に更新されていた）
    if (state == AppLifecycleState.resumed) {
      _loadAll();
    }
  }

  ///
  Future<void> _loadAll() async {
    // 読み込み中に再読み込み要求が来たら、終わった後にもう1周だけ読み直す（同時に複数走らせない）
    if (_loading) {
      _reloadRequested = true;
      return;
    }

    _loading = true;

    try {
      do {
        _reloadRequested = false;

        if (!mounted) {
          return;
        }

        // 依存関係の順に読む
        // （銀行残高の集計は設定値（buttonLabelTextList）を、支出の集計は消費アイテム一覧を使うため）
        await _makeConfigMap();
        await _makeSpendItemList();
        await _makeMoneyList();
        await _makeBankPriceList();
        await _makeSpendTimePlaceList();
        await _makeBankNameList();
      } while (_reloadRequested);
    } finally {
      _loading = false;

      // 読み込み途中で例外が起きた場合でも、その間に来た再読み込み要求は捨てない
      if (_reloadRequested && mounted) {
        // ignore: always_specify_types
        Future(_loadAll);
      }
    }
  }

  bool getAllTotalMoneyMap = false;

  Map<String, int> allTotalMoneyMap = <String, int>{};

  ///
  @override
  Widget build(BuildContext context) {
    // 初回と、表示する年月が変わったときだけ読み込む
    if (_loadedYearMonth != calendarsState.baseYearMonth) {
      _loadedYearMonth = calendarsState.baseYearMonth;

      // ignore: always_specify_types
      Future(_loadAll);
    }

    return DefaultTabController(
      length: _ymList.length,
      initialIndex: _getInitialTabIndex(),
      child: Builder(
        builder: (BuildContext tabContext) {
          final TabController newController = DefaultTabController.of(tabContext);
          if (newController != _tabController) {
            _tabController?.removeListener(_onTabChanged);
            _tabController = newController;
            _tabController?.addListener(_onTabChanged);
            // ignore: always_specify_types
            Future(() => calendarNotifier.setCalendarYearMonth(baseYm: _ymList[newController.index]));
          }

          return Scaffold(
            backgroundColor: Colors.blueGrey.withOpacity(0.3),
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('money note'),
              centerTitle: false,
              backgroundColor: Colors.transparent,
              bottom: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: Colors.blueAccent,
                padding: EdgeInsets.zero,
                tabs: _ymList.map((String ym) {
                  final bool isCurrent = ym == DateTime.now().yyyymm;
                  return Tab(
                    child: Text(
                      ym,
                      style: TextStyle(fontSize: 12, color: isCurrent ? Colors.greenAccent : Colors.white),
                    ),
                  );
                }).toList(),
              ),
              actions: <Widget>[
                if (appParamState.calendarDisp)
                  IconButton(
                    onPressed: () {
                      final List<int> years = <int>[];

                      // 前回開いたときの値（削除済みの日付を含む）が残らないよう、毎回作り直す
                      allTotalMoneyMap.clear();

                      dateCurrencySumMap.forEach(
                        (String key, int value) {
                          final List<String> exKey = key.split('-');
                          if (!years.contains(exKey[0].toInt())) {
                            years.add(exKey[0].toInt());
                          }

                          allTotalMoneyMap[key] = dateCurrencySumMap[key]! + bankPriceTotalPadMap[key]!;
                        },
                      );

                      final Map<String, int> spendMapMonthly = <String, int>{};

                      int mSpend = 0;
                      monthlySpendMap.forEach(
                        (String key, int value) {
                          mSpend += value;
                          spendMapMonthly[key] = mSpend;
                        },
                      );

                      MoneyDialog(
                        context: context,
                        widget: AllTotalMoneyGraphAlert(
                          allTotalMoneyMap: allTotalMoneyMap,
                          years: years,
                          isar: widget.isar,
                          monthlyDateSumMap: dateCurrencySumMap,
                          bankPriceTotalPadMap: bankPriceTotalPadMap,
                          monthlySpendMap: spendMapMonthly,
                          thisMonthSpendTimePlaceList: thisMonthSpendTimePlaceList ?? <SpendTimePlace>[],
                          allSpendTimePlaceList: allSpendTimePlaceList ?? <SpendTimePlace>[],
                        ),
                      );
                    },
                    icon: Icon(Icons.stacked_line_chart, color: Colors.white.withOpacity(0.6), size: 20),
                  ),
                IconButton(
                  onPressed: () {
                    final int idx = _ymList.indexOf(DateTime.now().yyyymm);
                    if (idx >= 0) {
                      _tabController?.animateTo(idx);
                    }
                  },
                  icon: Icon(Icons.refresh, color: Colors.white.withOpacity(0.6), size: 20),
                ),
                IconButton(
                  onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
                  icon: Icon(Icons.settings, color: Colors.white.withOpacity(0.6), size: 20),
                )
              ],
            ),
            body: TabBarView(
              children: List<Widget>.generate(
                _ymList.length,
                (int _) => Builder(builder: (BuildContext _) => _buildBodyContent()),
              ),
            ),
            endDrawer: _dispDrawer(),
          );
        },
      ),
    );
  }

  ///
  Widget _displayMonthSum() {
    int plusVal = 0;
    int minusVal = 0;

    if (thisMonthSpendTimePlaceList!.isNotEmpty) {
      for (final SpendTimePlace element in thisMonthSpendTimePlaceList!) {
        if (element.price > 0) {
          minusVal += element.price;
        } else {
          plusVal += element.price;
        }
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (appParamState.calendarDisp) ...<Widget>[
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      MoneyDialog(
                        context: context,
                        widget: SpendMonthlyListAlert(
                          isar: widget.isar,
                          date: DateTime.parse('${calendarsState.baseYearMonth}-01 00:00:00'),
                        ),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.calendar_month_rounded, color: Colors.white.withOpacity(0.8)),
                        const Text('日別'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      MoneyDialog(
                        context: context,
                        widget: SpendYearlyBlockAlert(
                          date: DateTime.parse('${calendarsState.baseYearMonth}-01 00:00:00'),
                          isar: widget.isar,
                          allSpendTimePlaceList: allSpendTimePlaceList ?? <SpendTimePlace>[],
                        ),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.calendar_month_rounded, color: Colors.white.withOpacity(0.8)),
                        const Text('年間'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            if (!appParamState.calendarDisp) ...<Widget>[const SizedBox.shrink()],
            Row(
              children: <Widget>[
                DefaultTextStyle(
                  style: const TextStyle(color: Colors.yellowAccent, fontSize: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('支出'),
                      Text(minusVal.toString().toCurrency()),
                    ],
                  ),
                ),
                const Text('　+　'),
                DefaultTextStyle(
                  style: const TextStyle(color: Colors.greenAccent, fontSize: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('収入'),
                      Text((plusVal * -1).toString().toCurrency()),
                    ],
                  ),
                ),
                const Text('　=　'),
                DefaultTextStyle(
                  style: const TextStyle(color: Colors.orangeAccent, fontSize: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('収支'),
                      Text(((minusVal + plusVal) * -1).toString().toCurrency()),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    appParamNotifier.setSameDaySelectedDay(day: DateTime.now().day);

                    MoneyDialog(
                      context: context,
                      widget: SameDaySpendPriceListAlert(
                        isar: widget.isar,
                        spendTimePlaceList: allSpendTimePlaceList ?? <SpendTimePlace>[],
                      ),
                    );
                  },
                  child: FaIcon(FontAwesomeIcons.diamond, color: Colors.white.withOpacity(0.6), size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///
  Widget _displayKurikoshiPrice() {
    //=================================

    final List<String> exYm = calendarsState.baseYearMonth.split('-');

    final String lastMonthLastDate = DateTime(exYm[0].toInt(), exYm[1].toInt(), 0).yyyymmdd;

    final int kurikoshiMoney =
        (moneyMap[lastMonthLastDate] != null) ? _utility.makeCurrencySum(money: moneyMap[lastMonthLastDate]) : 0;

    final int bankPriceTotal =
        (bankPriceTotalPadMap[lastMonthLastDate] != null) ? bankPriceTotalPadMap[lastMonthLastDate]! : 0;

    final int kurikoshi = (kurikoshiMoney != 0 && bankPriceTotal != 0) ? (kurikoshiMoney + bankPriceTotal) : 0;

    //=================================

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[BoxShadow(blurRadius: 24, spreadRadius: 16, color: Colors.black.withOpacity(0.2))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            width: context.screenSize.width,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (appParamState.calendarDisp) ...<Widget>[
                  Row(
                    children: <Widget>[
                      const SizedBox(width: 10),
                      DefaultTextStyle(
                        style: const TextStyle(fontSize: 10),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 5),
                            const Text('繰越'),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.yellowAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(kurikoshi.toString().toCurrency()),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                if (!appParamState.calendarDisp) ...<Widget>[const SizedBox.shrink()],
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => appParamNotifier.setCalendarDisp(flag: !appParamState.calendarDisp),
                      icon: Icon(
                        Icons.calendar_month,
                        color:
                            appParamState.calendarDisp ? Colors.white.withOpacity(0.6) : Colors.grey.withOpacity(0.6),
                        size: 16,
                      ),
                    ),
                    if (appParamState.calendarDisp) ...<Widget>[
                      IconButton(
                        onPressed: () {
                          MoneyDialog(
                            context: context,
                            widget: MoneyListAlert(
                              isar: widget.isar,
                              date: DateTime.parse('${calendarsState.baseYearMonth}-01 00:00:00'),
                              moneyList: moneyList,
                              bankNameList: bankNameList,
                              emoneyNameList: emoneyNameList,
                              bankPricePadMap: bankPricePadMap,
                            ),
                          );
                        },
                        icon: FaIcon(FontAwesomeIcons.list, color: Colors.white.withOpacity(0.6), size: 16),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _buildBodyContent() {
    return Stack(
      children: <Widget>[
        const BackGroundImage(),
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: context.screenSize.height * 0.9,
            width: context.screenSize.width * 0.9,
            margin: const EdgeInsets.only(top: 5, left: 6),
            color: const Color(0xFFFBB6CE).withOpacity(0.6),
            child: Text('■', style: TextStyle(color: Colors.white.withOpacity(0.1))),
          ),
        ),
        Container(
          width: context.screenSize.width,
          height: context.screenSize.height,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
        ),
        SafeArea(
          child: Column(
            children: <Widget>[
              _displayKurikoshiPrice(),
              if (appParamState.calendarDisp) ...<Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: context.screenSize.height * 0.45),
                  child: _getCalendar(),
                ),
              ],
              if (!appParamState.calendarDisp) ...<Widget>[const SizedBox(height: 10)],
              _displayMonthSum(),
              Expanded(child: _displayMonthlySpendTimePlaceList()),
            ],
          ),
        ),
      ],
    );
  }

  ///
  Widget _dispDrawer() {
    const bool isRelease = bool.fromEnvironment('dart.vm.product');

    _updateButtonLabelTextList();

    return Drawer(
      backgroundColor: Colors.blueGrey.withOpacity(0.2),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 60),
              if (!isRelease) ...<Widget>[
                GestureDetector(
                  onTap: () => MoneyDialog(context: context, widget: DummyDataInputAlert(isar: widget.isar)),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(0.4))),
                    child: const Text('dummy data input'),
                  ),
                ),
              ],
              GestureDetector(
                onTap: () {
                  MoneyDialog(
                    context: context,
                    widget: ConfigSettingAlert(isar: widget.isar, baseYm: calendarsState.baseYearMonth),
                  );
                },
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('設定'),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              if (buttonLabelTextList.isNotEmpty) ...<Widget>[
                GestureDetector(
                  onTap: () => MoneyDialog(
                    context: context,
                    widget: DepositTabAlert(isar: widget.isar, buttonLabelTextList: buttonLabelTextList),
                  ),
                  child: Row(
                    children: <Widget>[
                      const MenuHeadIcon(),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                          margin: const EdgeInsets.all(5),
                          child: Text('${buttonLabelTextList.join('、')}名称登録'),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    appParamNotifier.setInputButtonClicked(flag: false);

                    MoneyDialog(
                      context: context,
                      widget: BankPriceAdjustAlert(
                        isar: widget.isar,
                        bankNameList: bankNameList,
                        emoneyNameList: emoneyNameList,
                        buttonLabelTextList: buttonLabelTextList,
                      ),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      const MenuHeadIcon(),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                          margin: const EdgeInsets.all(5),
                          child: Text('${buttonLabelTextList.join('、')}金額修正'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              GestureDetector(
                onTap: () async {
                  moneyRepairControllerNotifier.clearMoneyModelListData();

                  appParamNotifier.setRepairSelectValue(date: '', kind: -1);

                  appParamNotifier.setRepairSelectFlag(flag: false);

                  appParamNotifier.clearSelectedRepairRecordNumber();

                  await MoneyDialog(
                    context: context,
                    widget: DateMoneyRepairAlert(
                      date: DateTime.parse('${calendarsState.baseYearMonth}-01 00:00:00'),
                      isar: widget.isar,
                    ),
                    executeFunctionWhenDialogClose: true,
                    ref: ref,
                  );
                },
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('金種枚数修正'),
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  appParamNotifier.setDeleteSpendTimePlaceDate(date: '');

                  MoneyDialog(
                      context: context,
                      widget: SpendTimePlaceDeleteAlert(
                          date: DateTime.parse('${calendarsState.baseYearMonth}-01 00:00:00'),
                          isar: widget.isar,
                          allSpendTimePlaceList: allSpendTimePlaceList));
                },
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('詳細データ削除'),
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () async {
                  appParamNotifier.setSelectedIncomeYear(year: '');

                  if (mounted) {
                    await MoneyDialog(
                      context: context,
                      widget: IncomeInputAlert(
                        date: DateTime.parse('${calendarsState.baseYearMonth}-01 00:00:00'),
                        isar: widget.isar,
                      ),
                    );
                  }
                },
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('収入管理'),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  MoneyDialog(
                    context: context,
                    widget: SpendItemInputAlert(
                      isar: widget.isar,
                      spendItemList: _spendItemList ?? <SpendItem>[],
                      spendTimePlaceCountMap: spendTimePlaceCountMap,
                    ),
                  );
                },
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('消費アイテム管理'),
                      ),
                    ),
                  ],
                ),
              ),
              if (spendTypeBlankSpendTimePlaceList.isNotEmpty) ...<Widget>[
                GestureDetector(
                  onTap: () async {
                    await appParamNotifier.setInputButtonClicked(flag: false).then(
                      // ignore: always_specify_types
                      (value) {
                        if (mounted) {
                          MoneyDialog(
                            context: context,
                            widget: SpendItemReInputAlert(
                              isar: widget.isar,
                              spendItemList: _spendItemList ?? <SpendItem>[],
                              spendTypeBlankSpendTimePlaceList: spendTypeBlankSpendTimePlaceList,
                            ),
                          );
                        }
                      },
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      const MenuHeadIcon(),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                          margin: const EdgeInsets.all(5),
                          child: const Text('消費アイテム再設定'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              GestureDetector(
                onTap: () => MoneyDialog(
                  context: context,
                  widget: MoneyScoreListAlert(
                    isar: widget.isar,
                    monthFirstDateList: monthFirstDateList,
                    dateCurrencySumMap: dateCurrencySumMap,
                    bankPriceTotalPadMap: bankPriceTotalPadMap,
                    allSpendTimePlaceList: allSpendTimePlaceList ?? <SpendTimePlace>[],
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('収支一覧'),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              // GestureDetector(
              //   onTap: () {
              //     MoneyDialog(
              //       context: context,
              //       widget: DownloadDataListAlert(
              //         isar: widget.isar,
              //         moneyMap: moneyMap,
              //         allSpendTimePlaceList: allSpendTimePlaceList ?? <SpendTimePlace>[],
              //         bankNameList: bankNameList ?? <BankName>[],
              //         emoneyNameList: emoneyNameList ?? <EmoneyName>[],
              //         bankPricePadMap: bankPricePadMap,
              //         spendItem: _spendItemList ?? <SpendItem>[],
              //         incomeList: _incomeList ?? <Income>[],
              //       ),
              //     );
              //   },
              //   child: Row(
              //     children: <Widget>[
              //       const MenuHeadIcon(),
              //       Expanded(
              //         child: Container(
              //           width: double.infinity,
              //           padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
              //           margin: const EdgeInsets.all(5),
              //           child: const Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: <Widget>[
              //               Text('整形データダウンロード'),
              //               Text(
              //                 '（このファイルはインポートできません。）',
              //                 style: TextStyle(fontSize: 10, color: Colors.grey),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Divider(color: Colors.white.withOpacity(0.4), thickness: 1),
              GestureDetector(
                onTap: () => MoneyDialog(context: context, widget: DataExportAlert(isar: widget.isar)),
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('データエクスポート'),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => MoneyDialog(context: context, widget: DataImportAlert(isar: widget.isar)),
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('データインポート'),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

              GestureDetector(
                onTap: () => MoneyDialog(context: context, widget: const TableDataDeleteAlert()),
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('テーブルデータ削除'),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),

              GestureDetector(
                onTap: () => MoneyDialog(context: context, widget: LoginAccountDisplayAlert(isar: widget.isar)),
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('ログインアカウント管理'),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', false);
                  if (!mounted) {
                    return;
                  }
                  Navigator.pushReplacement(
                    context,

                    // ignore: inference_failure_on_instance_creation, always_specify_types
                    MaterialPageRoute(builder: (BuildContext context) => LoginScreen(isar: widget.isar)),
                  );
                },
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('LOGOUT'),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);

                  showLicensePage(
                    context: context,
                    applicationIcon: const FlutterLogo(),
                    applicationName: 'Money Note',
                    applicationLegalese: '\u{a9} ${DateTime.now().year} toyohide',
                    applicationVersion: '1.0',
                  );
                },
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('ライセンス表示'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _getCalendar() {
    monthlySpendMap = <String, int>{};

    if (holidayState.holidayMap.value != null) {
      _holidayMap = holidayState.holidayMap.value!;
    }

    _calendarMonthFirst = DateTime.parse('${calendarsState.baseYearMonth}-01 00:00:00');

    final DateTime monthEnd = DateTime.parse('${calendarsState.nextYearMonth}-00 00:00:00');

    final int diff = monthEnd.difference(_calendarMonthFirst).inDays;
    final int monthDaysNum = diff + 1;

    final String youbi = _calendarMonthFirst.youbiStr;
    final int youbiNum = _youbiList.indexWhere((String element) => element == youbi);

    final int weekNum = ((monthDaysNum + youbiNum) <= 35) ? 5 : 6;

    // ignore: always_specify_types
    _calendarDays = List.generate(weekNum * 7, (int index) => '');

    for (int i = 0; i < (weekNum * 7); i++) {
      if (i >= youbiNum) {
        final DateTime gendate = _calendarMonthFirst.add(Duration(days: i - youbiNum));

        if (_calendarMonthFirst.month == gendate.month) {
          _calendarDays[i] = gendate.day.toString();
        }
      }
    }

    final List<Widget> list = <Widget>[];
    for (int i = 0; i < weekNum; i++) {
      list.add(_getCalendarRow(week: i));
    }

    return DefaultTextStyle(style: const TextStyle(fontSize: 10), child: Column(children: list));
  }

  ///
  Widget _getCalendarRow({required int week}) {
    final List<Widget> list = <Widget>[];

    for (int i = week * 7; i < ((week + 1) * 7); i++) {
      final String generateYmd = (_calendarDays[i] == '')
          ? ''
          : DateTime(_calendarMonthFirst.year, _calendarMonthFirst.month, _calendarDays[i].toInt()).yyyymmdd;

      final String youbiStr = (_calendarDays[i] == '')
          ? ''
          : DateTime(_calendarMonthFirst.year, _calendarMonthFirst.month, _calendarDays[i].toInt()).youbiStr;

      int dateDiff = 0;
      int dateSum = 0;
      if (generateYmd != '') {
        final DateTime genDate = DateTime.parse('$generateYmd 00:00:00');
        dateDiff = genDate.difference(DateTime.now()).inSeconds;

        if (dateCurrencySumMap[generateYmd] != null && bankPriceTotalPadMap[generateYmd] != null) {
          dateSum = dateCurrencySumMap[generateYmd]! + bankPriceTotalPadMap[generateYmd]!;
        }
      }

      //-----------------------------------------------//
      int zenjitsuSum = 0;
      final String zenjitsu = (_calendarDays[i] == '')
          ? ''
          : DateTime(_calendarMonthFirst.year, _calendarMonthFirst.month, _calendarDays[i].toInt() - 1).yyyymmdd;

      if (zenjitsu != '') {
        if (dateCurrencySumMap[zenjitsu] != null && bankPriceTotalPadMap[zenjitsu] != null) {
          zenjitsuSum = dateCurrencySumMap[zenjitsu]! + bankPriceTotalPadMap[zenjitsu]!;
        }
      }

      //-----------------------------------------------//

      /////////////////////////////////////////

      bool inputedFlag = false;

      if ((monthlySpendTimePlaceSumMap[generateYmd] != null &&
              (zenjitsuSum - dateSum) == monthlySpendTimePlaceSumMap[generateYmd]) ||
          (zenjitsuSum - dateSum) == 0) {
        inputedFlag = true;
      }

      /////////////////////////////////////////

      list.add(
        Expanded(
          child: GestureDetector(
            onTap: (_calendarDays[i] == '' || dateDiff > 0)
                ? null
                : () => MoneyDialog(
                      context: context,
                      widget: DailyMoneyDisplayAlert(
                        date: DateTime.parse('$generateYmd 00:00:00'),
                        isar: widget.isar,
                        moneyMap: moneyMap,
                        bankPricePadMap: bankPricePadMap,
                        bankPriceTotalPadMap: bankPriceTotalPadMap,
                        bankNameList: bankNameList ?? <BankName>[],
                        emoneyNameList: emoneyNameList ?? <EmoneyName>[],
                        spendItemList: _spendItemList ?? <SpendItem>[],
                        thisMonthSpendTimePlaceList: thisMonthSpendTimePlaceList ?? <SpendTimePlace>[],
                        prevMonthSpendTimePlaceList: prevMonthSpendTimePlaceList ?? <SpendTimePlace>[],
                        buttonLabelTextList: buttonLabelTextList,
                      ),
                    ),
            child: Container(
              margin: const EdgeInsets.all(1),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: (_calendarDays[i] == '')
                      ? Colors.transparent
                      : (generateYmd == DateTime.now().yyyymmdd)
                          ? Colors.orangeAccent.withOpacity(0.4)
                          : Colors.white.withOpacity(0.1),
                  width: 3,
                ),
                color: (_calendarDays[i] == '')
                    ? Colors.transparent
                    : (dateDiff > 0)
                        ? Colors.white.withOpacity(0.1)
                        : _utility.getYoubiColor(date: generateYmd, youbiStr: youbiStr, holidayMap: _holidayMap),
              ),
              child: (_calendarDays[i] == '')
                  ? const Text('')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(_calendarDays[i].padLeft(2, '0')),
                            if (dateDiff > 0 || dateSum == 0)
                              const SizedBox.shrink()
                            else
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: inputedFlag
                                          ? Colors.yellowAccent.withOpacity(0.3)
                                          : Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        ConstrainedBox(
                          constraints: BoxConstraints(minHeight: context.screenSize.height / 25),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const SizedBox.shrink(),
                                  if (dateDiff > 0 || dateSum == 0)
                                    const SizedBox.shrink()
                                  else
                                    Text(
                                      (zenjitsuSum - dateSum).toString().toCurrency(),
                                      style: const TextStyle(fontSize: 8),
                                    ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const SizedBox.shrink(),
                                  if (dateDiff > 0 || dateSum == 0)
                                    const SizedBox.shrink()
                                  else
                                    Text(dateSum.toString().toCurrency(), style: const TextStyle(fontSize: 8)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );

      if (generateYmd != '') {
        if (DateTime.parse('$generateYmd 00:00:00').isBefore(DateTime.now())) {
          monthlySpendMap[generateYmd] = zenjitsuSum - dateSum;
        }
      }
    }

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: list);
  }

  ///
  Future<void> _makeMoneyList() async {
    await MoneysRepository().getMoneyList(isar: widget.isar).then(
      (List<Money>? value) {
        if (mounted) {
          setState(
            () {
              moneyList = value;

              // 以前は追記だけでクリアしていなかったため、削除した記録の値がアプリ再起動まで残っていた。
              // ダイアログにも同じインスタンスを渡しているので、作り直さずに中身を入れ替える
              dateCurrencySumMap.clear();
              moneyMap.clear();
              monthFirstDateList.clear();

              if (value!.isNotEmpty) {
                value
                  ..forEach(
                    (Money element) => dateCurrencySumMap[element.date] = _utility.makeCurrencySum(money: element),
                  )
                  ..forEach((Money element) => moneyMap[element.date] = element)
                  ..forEach(
                    (Money element) {
                      final List<String> exDate = element.date.split('-');
                      if (exDate[2].toInt() == 1) {
                        if (!monthFirstDateList.contains(element.date)) {
                          monthFirstDateList.add(element.date);
                        }
                      }
                    },
                  );
              }
            },
          );
        }
      },
    );
  }

  ///
  Future<void> _makeBankPriceList() async {
    await BankPricesRepository().getBankPriceList(isar: widget.isar).then(
      (List<BankPrice>? value) {
        if (mounted) {
          setState(
            () {
              bankPriceList = value;

              if (value != null) {
                final Map<String, dynamic> bankPriceMap =
                    makeBankPriceMap(bankPriceList: value, buttonLabelTextList: buttonLabelTextList);
                bankPricePadMap = bankPriceMap['bankPriceDatePadMap'] as Map<String, Map<String, int>>;
                bankPriceTotalPadMap = bankPriceMap['bankPriceTotalPadMap'] as Map<String, int>;
              }
            },
          );
        }
      },
    );
  }

  ///
  Future<void> _makeSpendTimePlaceList() async {
    spendTypeBlankSpendTimePlaceList = <SpendTimePlace>[];

    await SpendTimePlacesRepository().getSpendTimePlaceList(isar: widget.isar).then(
      (List<SpendTimePlace>? value) {
        if (mounted) {
          setState(
            () {
              allSpendTimePlaceList = value;

              // 以前は追記だけでクリアしていなかったため、削除した記録の値がアプリ再起動まで残っていた。
              // （明細が0件になった場合も、前回の集計が残らないようにここで空にしておく）
              monthlySpendTimePlaceSumMap.clear();
              thisMonthSpendTimePlaceList = <SpendTimePlace>[];
              prevMonthSpendTimePlaceList = <SpendTimePlace>[];

              if (_spendItemList != null) {
                spendTimePlaceCountMap = <String, List<SpendTimePlace>>{
                  for (final SpendItem element in _spendItemList!) element.spendItemName: <SpendTimePlace>[],
                };
              }

              if (value!.isNotEmpty) {
                final String yearmonth = calendarsState.baseYearMonth;

                final String prevYearMonth =
                    DateTime(yearmonth.split('-')[0].toInt(), yearmonth.split('-')[1].toInt() - 1).yyyymm;

                if (_spendItemList != null) {
                  final Map<String, List<SpendTimePlace>> map = <String, List<SpendTimePlace>>{};
                  for (final SpendItem element in _spendItemList!) {
                    map[element.spendItemName] = <SpendTimePlace>[];
                  }
                  for (final SpendTimePlace element in value) {
                    map[element.spendType]?.add(element);
                  }
                  spendTimePlaceCountMap = map;
                }

                final List<SpendTimePlace> list = <SpendTimePlace>[];
                final List<SpendTimePlace> list2 = <SpendTimePlace>[];

                final Map<String, List<int>> map = <String, List<int>>{};

                value
                  ..forEach(
                    (SpendTimePlace element) {
                      final List<String> exDate = element.date.split('-');

                      if ('${exDate[0]}-${exDate[1]}' == yearmonth) {
                        map[element.date] = <int>[];
                      }
                    },
                  )
                  ..forEach(
                    (SpendTimePlace element) {
                      final List<String> exDate = element.date.split('-');

                      if ('${exDate[0]}-${exDate[1]}' == yearmonth) {
                        map[element.date]?.add(element.price);

                        list.add(element);
                      }

                      if ('${exDate[0]}-${exDate[1]}' == prevYearMonth) {
                        list2.add(element);
                      }

                      if (element.spendType == '') {
                        spendTypeBlankSpendTimePlaceList.add(element);
                      }
                    },
                  );

                map.forEach(
                  (String key, List<int> value) {
                    int sum = 0;
                    for (final int element in value) {
                      sum += element;
                    }
                    monthlySpendTimePlaceSumMap[key] = sum;
                  },
                );

                thisMonthSpendTimePlaceList = list;

                prevMonthSpendTimePlaceList = list2;
              }
            },
          );
        }
      },
    );
  }

  ///
  Widget _displayMonthlySpendTimePlaceList() {
    final List<Widget> list = <Widget>[];

    final Map<String, List<int>> stpListMinus = <String, List<int>>{};
    final Map<String, List<int>> stpListPlus = <String, List<int>>{};

    _spendItemList?.forEach(
      (SpendItem element) {
        stpListMinus[element.spendItemName] = <int>[];
        stpListPlus[element.spendItemName] = <int>[];
      },
    );

    thisMonthSpendTimePlaceList?.forEach(
      (SpendTimePlace element) {
        if (element.price < 0) {
          stpListMinus[element.spendType]?.add(element.price);
        } else {
          stpListPlus[element.spendType]?.add(element.price);
        }
      },
    );

    _spendItemList?.forEach(
      (SpendItem element) {
        int minusSum = 0;
        stpListMinus[element.spendItemName]?.forEach((int element2) => minusSum += element2);

        int plusSum = 0;
        stpListPlus[element.spendItemName]?.forEach((int element2) => plusSum += element2);

        if (minusSum == 0 && plusSum == 0) {
        } else {
          list.add(
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(radius: 10, backgroundColor: Color(element.color.toInt()).withOpacity(0.3)),
                          const SizedBox(width: 10),
                          Text(element.spendItemName),
                        ],
                      )),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: FittedBox(
                        child: Text(
                          plusSum.toString().toCurrency(),
                          style: const TextStyle(color: Colors.yellowAccent, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: FittedBox(
                        child: Text(
                          (minusSum * -1).toString().toCurrency(),
                          style: const TextStyle(color: Colors.greenAccent, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: FittedBox(
                        child: Text(
                          ((plusSum + minusSum) * -1).toString().toCurrency(),
                          style: const TextStyle(color: Colors.orangeAccent, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => MoneyDialog(
                      context: context,
                      widget: SpendItemHistoryAlert(
                        date: DateTime.parse('${calendarsState.baseYearMonth}-01 00:00:00'),
                        isar: widget.isar,
                        item: element.spendItemName,
                        sum: plusSum + minusSum,
                        from: 'home_screen',
                      ),
                    ),
                    child: Icon(Icons.info_outline_rounded, color: Colors.blueAccent.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) =>
                DefaultTextStyle(style: const TextStyle(fontFamily: 'KiwiMaru', fontSize: 12), child: list[index]),
            childCount: list.length,
          ),
        ),
      ],
    );
  }

  ///
  Future<void> _makeBankNameList() async {
    depoNameList = <Deposit>[];

    await BankNamesRepository().getBankNameList(isar: widget.isar).then(
      (List<BankName>? value) {
        if (mounted) {
          setState(
            () {
              bankNameList = value;

              if (value!.isNotEmpty) {
                for (final BankName element in value) {
                  depoNameList.add(
                    Deposit('${element.depositType}-${element.id}', '${element.bankName} ${element.branchName}'),
                  );
                }
              }
            },
          );
        }
      },
    );

    await _makeEmoneyNameList();
  }

  ///
  Future<void> _makeEmoneyNameList() async {
    await EmoneyNamesRepository().getEmoneyNameList(isar: widget.isar).then(
      (List<EmoneyName>? value) {
        if (mounted) {
          setState(
            () {
              emoneyNameList = value;

              if (value!.isNotEmpty) {
                for (final EmoneyName element in value) {
                  depoNameList.add(Deposit('${element.depositType}-${element.id}', element.emoneyName));
                }
              }
            },
          );
        }
      },
    );
  }

  ///
  Future<void> _makeSpendItemList() async => SpendItemsRepository().getSpendItemList(isar: widget.isar).then(
        (List<SpendItem>? value) {
          if (mounted) {
            setState(() => _spendItemList = value);
          }
        },
      );


  ///
  Future<void> _makeConfigMap() async {
    await ConfigsRepository().getConfigList(isar: widget.isar).then(
      (List<Config>? value) {
        if (mounted) {
          setState(
            () {
              // 以前は追記だけでクリアしていなかったため、削除した記録の値がアプリ再起動まで残っていた。
              configMap.clear();

              if (value!.isNotEmpty) {
                for (final Config element in value) {
                  configMap[element.configKey] = element.configValue;
                }
              }

              // 銀行残高の集計（_makeBankPriceList）で使うので、描画を待たずにここで更新しておく
              _updateButtonLabelTextList();
            },
          );
        }
      },
    );
  }

  ///
  void _updateButtonLabelTextList() {
    buttonLabelTextList.clear();

    if (configMap['useBankManage'] != 'false') {
      buttonLabelTextList.add('金融機関');
    }

    if (configMap['useEmoneyManage'] != 'false') {
      buttonLabelTextList.add('電子マネー');
    }
  }
}
