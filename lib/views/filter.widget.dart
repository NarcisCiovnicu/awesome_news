import 'package:awesome_news/models/sort_criteria.model.dart';
import 'package:awesome_news/view_models/filters.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FilterDialogWidget extends StatelessWidget {
  FilterDialogWidget({super.key});

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    FiltersViewModel filtersVM = context.watch<FiltersViewModel>();

    return AlertDialog(
      scrollable: true,
      title: const Text("Filters"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _searchField(filtersVM),
            _minPointsField(filtersVM),
            _maxPointsField(filtersVM),
            _dateField(context, filtersVM),
            _sortByDropdown(filtersVM),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, filtersVM.toSeachCriteria());
            }
          },
          child: const Text('Search'),
        ),
      ],
    );
  }

  Widget _searchField(FiltersViewModel filtersVM) {
    return TextFormField(
      initialValue: filtersVM.searchQuery,
      onChanged: (newValue) {
        filtersVM.searchQuery = newValue;
      },
      decoration: const InputDecoration(
        label: Text("Search"),
      ),
    );
  }

  Widget _minPointsField(FiltersViewModel filtersVM) {
    return TextFormField(
      initialValue: filtersVM.minPoints?.toString(),
      keyboardType: TextInputType.number,
      onChanged: (newValue) {
        filtersVM.minPoints = int.tryParse(newValue);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return null;
        }
        int? number = int.tryParse(value);
        if (number == null) {
          return "Please enter a number";
        }
        if (number < 0 || number > 9999) {
          return "Enter a number between 0 and 9.999";
        }
        if (filtersVM.maxPoints != null && filtersVM.maxPoints! < number) {
          return "MIN <= MAX !!!";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Min points",
      ),
    );
  }

  Widget _maxPointsField(FiltersViewModel filtersVM) {
    return TextFormField(
      initialValue: filtersVM.maxPoints?.toString(),
      keyboardType: TextInputType.number,
      onChanged: (newValue) {
        filtersVM.maxPoints = int.tryParse(newValue);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return null;
        }
        int? number = int.tryParse(value);
        if (number == null) {
          return "Please enter a number";
        }
        if (number < 0 || number > 9999) {
          return "Enter a number between 0 and 9.999";
        }
        if (filtersVM.minPoints != null && filtersVM.minPoints! > number) {
          return "MAX >= MIN !!!";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Max points",
      ),
    );
  }

  Widget _dateField(BuildContext context, FiltersViewModel filtersVM) {
    String startDate = "Start date";
    String endDate = "End date";
    if (filtersVM.dateRange != null) {
      startDate = DateFormat("d/M/yyyy").format(filtersVM.dateRange!.start);
      endDate = DateFormat("d/M/yyyy").format(filtersVM.dateRange!.end);
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            child: Text(startDate),
            onPressed: () async {
              filtersVM.dateRange = await _pickDateRange(context);
              filtersVM.updateUI();
            },
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ElevatedButton(
            child: Text(endDate),
            onPressed: () async {
              filtersVM.dateRange = await _pickDateRange(context);
              filtersVM.updateUI();
            },
          ),
        ),
      ],
    );
  }

  Future<DateTimeRange?> _pickDateRange(BuildContext context) async {
    return showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
  }

  Widget _sortByDropdown(FiltersViewModel filtersVM) {
    return DropdownButtonFormField<NewsSortCriteria>(
      decoration: const InputDecoration(
        label: Text("Sort by:"),
      ),
      value: filtersVM.sortBy,
      isExpanded: true,
      onChanged: (value) {
        filtersVM.sortBy = value!;
      },
      items: const [
        DropdownMenuItem<NewsSortCriteria>(
          value: NewsSortCriteria.None,
          child: Text("None"),
        ),
        DropdownMenuItem<NewsSortCriteria>(
          value: NewsSortCriteria.Points,
          child: Text("Points"),
        ),
        DropdownMenuItem<NewsSortCriteria>(
          value: NewsSortCriteria.PublishedDate,
          child: Text("Published date"),
        ),
      ],
    );
  }
}
