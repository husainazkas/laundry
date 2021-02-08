import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/bloc/history_bloc.dart';
import 'package:laundry/model/order_details_model.dart';
import 'package:laundry/ui/widget/history_card.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> with SingleTickerProviderStateMixin {
  final HistoryBloc _historyBloc = HistoryBloc(HistoryInitial());
  final List<String> _tab = [
    'Dalam Perjalanan',
    'Sedang Diproses',
    'Selesai',
    'Batal'
  ];

  TabController _controller;
  int _tabIndex = 0;
  Sort _sort = Sort.desc;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: _tab.length, vsync: this);
    _controller.addListener(() {
      setState(() => _tabIndex = _controller.index);
    });
    _historyBloc.add(HistoryEvent(_sort));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _controller,
          labelPadding: EdgeInsets.all(14.0),
          isScrollable: true,
          indicatorColor: Colors.white,
          onTap: (index) => setState(() => _tabIndex = index),
          tabs: List.generate(_tab.length, (index) {
            return Text(
              _tab[index],
              style: TextStyle(
                fontWeight: _tabIndex == index ? FontWeight.bold : null,
              ),
            );
          }),
        ),
        title: Text('Riwayat Pemesanan'),
        centerTitle: true,
        actions: [
          PopupMenuButton<Sort>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              _sort = value;
              _historyBloc.add(HistoryEvent(value));
            },
            itemBuilder: (context) {
              return Sort.values.reversed.map((sort) {
                String text;
                switch (sort) {
                  case Sort.asc:
                    text = 'Urut terlawas';
                    break;
                  case Sort.desc:
                    text = 'Urut terbaru';
                    break;
                }
                return PopupMenuItem<Sort>(
                  value: sort,
                  child: IgnorePointer(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<Sort>(
                          groupValue: _sort,
                          value: sort,
                          onChanged: (value) {},
                        ),
                        Text(text),
                      ],
                    ),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: BlocProvider<HistoryBloc>(
        create: (context) => _historyBloc,
        child: TabBarView(
          controller: _controller,
          children:
              List.generate(_tab.length, (index) => historyTab(_tab[index])),
        ),
      ),
    );
  }

  Widget historyTab(String title) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state is HistoryInProgress) {
          return Container(
            width: 120.0,
            height: 120.0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is HistoryFailure) {
          return Center(
            child: Text('Terjadi kesalahan.\nHarap coba lagi nanti.'),
          );
        } else if (state is HistorySuccess) {
          List<OrderDetails> data =
              state.getData(title.toLowerCase().split(' ').join());
          if (data.isNotEmpty) {
            return HistoryCard(data);
          } else {
            return Center(
              child: Text('Upss.. Anda belum memiliki riwayat ini.'),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
