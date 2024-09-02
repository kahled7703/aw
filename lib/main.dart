import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'database_helper.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login and Main Interface',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String correctEmail = "user@example.com";
  final String correctPassword = "123";

  void _login() {
    if (_formKey.currentState!.validate()) {
      if (_emailController.text == correctEmail && _passwordController.text == correctPassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تسجيل الدخول'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/khaled.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                  maxLength: 50,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                  obscureText: true,
                  maxLength: 50,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final String email;
  final String password;

  MainPage({required this.email, required this.password});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  Widget getPage(int index) {
    switch (index) {
      case 0:
      //  return SettingsPage();
      case 1:
        return ReportPage();
      case 2:
        return AddAssociationPage(); // Non-const widget
      case 3:
        return PersonalAccountPage();
      case 4:
        return SendReportPage();
      default:
        return Container();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مرحبا بك في تطبيق الجمعيات'),
      ),
      body: Center(
        child: getPage(_selectedIndex)
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'عدادات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'تقرير',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'اضافة جمعية ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'الحساب الشخصي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: 'ارسل رسالة',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Example of AddAssociationPage as a StatefulWidget instead of StatelessWidget
class AddAssociationPage extends StatefulWidget {
  @override
  _AddAssociationPageState createState() => _AddAssociationPageState();
}

class _AddAssociationPageState extends State<AddAssociationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الجمعية'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewAssociationPage()));
                    },
                  ),
                ),
                Text('اضافة جمعية جديده'),
                SizedBox(height: 16),
                CircleAvatar(
                  radius: 30,
                  child: IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>AddNewAssociationPage()));
                    },
                  ),
                ),
                Text('معلومات الجمعية'),
                SizedBox(height: 16),
                CircleAvatar(
                  radius: 30,
                  child: IconButton(
                    icon: Icon(Icons.data_usage),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DailyDataPage()));
                    },
                  ),
                ),
                Text('عرض البيانات اليومية'),
                SizedBox(height: 16),
                CircleAvatar(
                  radius: 30,
                  child: IconButton(
                    icon: Icon(Icons.payment),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentsPage()));
                    },
                  ),
                ),
                Text('المدفوعات'),
                SizedBox(height: 16),
                CircleAvatar(
                  radius: 30,
                  child: IconButton(
                    icon: Icon(Icons.monetization_on),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoansPage()));
                    },
                  ),
                ),
                Text('سلف الجمعية'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Association {
  final int? id; // Add an ID field to uniquely identify associations in the database
  final String name;
  final int members;
  final int days;
  final double subscriptionAmount;
  final List<Member> memberDetails;
  List<DateTime> deliveryDates;
  Timer? timer;
  int? remainingDays;
  Member? withdrawnMember;
  DateTime? startTime;
  DateTime? pausedTime;
  String? elapsedTime;
  List<Member> withdrawnMembers;

  Association({
    this.id, // ID is optional, only used when retrieving from the database
    required this.name,
    required this.members,
    required this.days,
    required this.subscriptionAmount,
    required this.memberDetails,
    required this.deliveryDates,
    this.timer,
    this.remainingDays,
    this.withdrawnMember,
    this.startTime,
    this.pausedTime,
    this.elapsedTime,
    this.withdrawnMembers = const [],
  });

  // Convert an Association object into a Map to insert/update it in the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'members': members,
      'days': days,
      'subscriptionAmount': subscriptionAmount,
      'startTime': startTime?.millisecondsSinceEpoch,
      'pausedTime': pausedTime?.millisecondsSinceEpoch,
      'elapsedTime': elapsedTime,
      'remainingDays': remainingDays,
    };
  }

  // Create an Association object from a Map retrieved from the database
  factory Association.fromMap(Map<String, dynamic> map) {
    return Association(
      id: map['id'],
      name: map['name'],
      members: map['members'],
      days: map['days'],
      subscriptionAmount: map['subscriptionAmount'],
      startTime: map['startTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startTime'])
          : null,
      pausedTime: map['pausedTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['pausedTime'])
          : null,
      elapsedTime: map['elapsedTime'],
      remainingDays: map['remainingDays'],
      memberDetails: [], // Needs to be populated separately
      deliveryDates: [], // Needs to be populated separately
      withdrawnMembers: [], // Needs to be populated separately
    );
  }
}

class Member {
  int? id; // ID لكل عضو، يمكن أن يكون null في حالة عدم الحفظ بعد
  int associationId; // ID الخاص بالجمعية التي ينتمي إليها العضو
  String name; // اسم العضو
  double contribution; // مبلغ المساهمة للعضو
  String shares; // الأسهم التي يمتلكها العضو (سهم كامل، نصف سهم، إلخ)
  String phoneNumber; // رقم الهاتف للعضو

  Member({
    this.id,
    required this.associationId,
    required this.name,
    required this.contribution,
    required this.shares,
    required this.phoneNumber,
  });

  // لتحويل الكائن إلى خريطة (Map) لاستخدامها مع SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'associationId': associationId,
      'name': name,
      'contribution': contribution,
      'shares': shares,
      'phoneNumber': phoneNumber,
    };
  }

  // لتحويل خريطة (Map) إلى كائن Member
  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'],
      associationId: map['associationId'],
      name: map['name'],
      contribution: map['contribution'],
      shares: map['shares'],
      phoneNumber: map['phoneNumber'],
    );
  }
}
  class AddNewAssociationPage extends StatefulWidget {
  @override
  _AddNewAssociationPageState createState() => _AddNewAssociationPageState();
}

class _AddNewAssociationPageState extends State<AddNewAssociationPage> {
  List<Association> _associations = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _membersController = TextEditingController();
  TextEditingController _daysController = TextEditingController();
  TextEditingController _subscriptionAmountController = TextEditingController();

  List<TextEditingController> _memberNameControllers = [];
  List<TextEditingController> _memberContributionControllers = [];
  List<TextEditingController> _sharesControllers = [];
  List<TextEditingController> _phoneNumberControllers = [];

  void _showAddAssociationDialog({Association? association, int? index}) {
    if (association != null) {
      _nameController.text = association.name;
      _membersController.text = association.members.toString();
      _daysController.text = association.days.toString();
      _subscriptionAmountController.text =
          association.subscriptionAmount.toString();
      _memberNameControllers = association.memberDetails.map((member) =>
          TextEditingController(text: member.name)).toList();
      _memberContributionControllers = association.memberDetails.map((member) =>
          TextEditingController(text: member.contribution.toString())).toList();
      _sharesControllers = association.memberDetails.map((member) =>
          TextEditingController(text: member.shares)).toList();
      _phoneNumberControllers = association.memberDetails.map((member) =>
          TextEditingController(text: member.phoneNumber)).toList();
    } else {
      _nameController.clear();
      _membersController.clear();
      _daysController.clear();
      _subscriptionAmountController.clear();
      _memberNameControllers.clear();
      _memberContributionControllers.clear();
      _sharesControllers.clear();
      _phoneNumberControllers.clear();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(association == null ? 'اضافة جمعية' : 'تعديل جمعية'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'اسم الجمعية',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _membersController,
                  decoration: InputDecoration(
                    labelText: 'الاعضاء',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _daysController,
                  decoration: InputDecoration(
                    labelText: 'عدد الايام',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _subscriptionAmountController,
                  decoration: InputDecoration(
                    labelText: 'مبلغ الاشتراك',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                int memberCount = int.tryParse(_membersController.text) ?? 0;
                if (memberCount > 0) {
                  _memberNameControllers = List<TextEditingController>.generate(
                      memberCount, (index) => TextEditingController());
                  _memberContributionControllers =
                  List<TextEditingController>.generate(
                      memberCount, (index) => TextEditingController());
                  _sharesControllers = List<TextEditingController>.generate(
                      memberCount, (index) => TextEditingController());
                  _phoneNumberControllers =
                  List<TextEditingController>.generate(
                      memberCount, (index) => TextEditingController());
                  Navigator.of(context).pop(); // Close dialog
                  _showMembersDialog(memberCount, association, index);
                }
              },
              child: Text(association == null ? 'اضافة' : 'تعديل'),
            ),
          ],
        );
      },
    );
  }

  void _showMembersDialog(int memberCount, Association? association,
      int? index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('اضافة اعضاء'),
          content: SingleChildScrollView(
            child: Column(
              children: List.generate(memberCount, (index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: TextField(
                        controller: _memberNameControllers[index],
                        decoration: InputDecoration(
                          labelText: 'اسم العضو ${index + 1}',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: TextField(
                        controller: _memberContributionControllers[index],
                        decoration: InputDecoration(
                          labelText: 'مبلغ المساهمة ${index + 1}',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          double subscriptionAmount = double.tryParse(
                              _subscriptionAmountController.text) ?? 0.0;
                          double contribution = double.tryParse(value) ?? 0.0;
                          _sharesControllers[index].text = _calculateShares(
                              contribution, subscriptionAmount);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: TextField(
                        controller: _sharesControllers[index],
                        decoration: InputDecoration(
                          labelText: 'الأسهم ${index + 1}',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: TextField(
                        controller: _phoneNumberControllers[index],
                        decoration: InputDecoration(
                          labelText: 'رقم الهاتف ${index + 1}',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (association == null) {
                  _addAssociation();
                } else {
                  _updateAssociation(index!);
                }
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('حفظ الجمعية'),
            ),
          ],
        );
      },
    );
  }

  String _calculateShares(double contribution, double subscriptionAmount) {
    if (subscriptionAmount == 0) return '';
    double fraction = contribution / subscriptionAmount;
    if (fraction == 1) return 'سهم كامل';
    if (fraction == 0.5) return 'نصف سهم';
    if (fraction == 0.25) return 'ربع سهم';
    if (fraction == 0.125) return 'ثمن سهم';
    return '${fraction.toStringAsFixed(2)} سهم';
  }
  void _addAssociation() async {
    List<Member> memberDetails = List.generate(
      _memberNameControllers.length,
          (index) => Member(
        name: _memberNameControllers[index].text,
        contribution: double.tryParse(_memberContributionControllers[index].text) ?? 0.0,
        shares: _sharesControllers[index].text,
        phoneNumber: _phoneNumberControllers[index].text,
        associationId: 0, // تحتاج إلى تحديد قيمة افتراضية أو معرف الجمعية
      ),
    );

    int days = int.tryParse(_daysController.text) ?? 0;
    List<DateTime> deliveryDates = List.generate(
      memberDetails.length,
          (index) => DateTime.now().add(Duration(days: days * index)),
    );

    Association newAssociation = Association(
      name: _nameController.text,
      members: int.tryParse(_membersController.text) ?? 0,
      days: days,
      subscriptionAmount: double.tryParse(_subscriptionAmountController.text) ?? 0.0,
      startTime: DateTime.now(), // استخدام الوقت الحالي كبداية
      pausedTime: null, // قيمة افتراضية يمكن تعديلها لاحقاً
      elapsedTime: null, memberDetails: [], deliveryDates: [], // قيمة افتراضية يمكن تعديلها لاحقاً
    );

    try {
      int result = await DatabaseHelper().insertAssociation(newAssociation);

      if (result > 0) {
        // تنظيف الحقول بعد الإدخال
        _clearControllers();

        // عرض رسالة نجاح باستخدام Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Association added successfully'),
          ),
        );

        // تحميل البيانات وتحديث واجهة المستخدم
        await _loadAssociations(); // قم بتحميل البيانات بعد الإضافة
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add association'),
          ),
        );
      }
    } catch (e) {
      print("Error adding association: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding association: $e'),
        ),
      );
    }
  }
  Future<void> _loadAssociations() async {
    try {
      List<Association> associations = await DatabaseHelper().getAssociations();
      setState(() {
        _associations = associations; // تحديث حالة البيانات
      });
    } catch (e) {
      print("Error loading associations: $e");
    }
  }

  void _clearControllers() {
    _nameController.clear();
    _membersController.clear();
    _daysController.clear();
    _subscriptionAmountController.clear();
    _memberNameControllers.forEach((controller) => controller.clear());
    _memberContributionControllers.forEach((controller) => controller.clear());
    _sharesControllers.forEach((controller) => controller.clear());
    _phoneNumberControllers.forEach((controller) => controller.clear());
  }

  void _updateAssociation(int index) async {
    Association association = _associations[index];

    // Create updated member details
    List<Member> updatedMemberDetails = List.generate(
      _memberNameControllers.length,
          (i) =>
          Member(
            id: association.memberDetails[i].id,
            // Preserve the original ID
            associationId: association.id!,
            // Association ID
            name: _memberNameControllers[i].text,
            contribution: double.parse(_memberContributionControllers[i].text),
            shares: _sharesControllers[i].text,
            phoneNumber: _phoneNumberControllers[i].text,
          ),
    );

    // Create updated association object
    Association updatedAssociation = Association(
      id: association.id,
      // Preserve the original ID
      name: _nameController.text,
      members: int.parse(_membersController.text),
      days: int.parse(_daysController.text),
      subscriptionAmount: double.parse(_subscriptionAmountController.text),
      memberDetails: updatedMemberDetails,
      deliveryDates: association.deliveryDates,
      // Preserve existing delivery dates
      timer: association.timer,
      remainingDays: association.remainingDays,
      withdrawnMember: association.withdrawnMember,
      startTime: association.startTime,
      pausedTime: association.pausedTime,
      elapsedTime: association.elapsedTime,
      withdrawnMembers: association.withdrawnMembers,
    );

    // Update association in database
    await DatabaseHelper().updateAssociation(
        updatedAssociation.id!, updatedAssociation);

    // Update state
    setState(() {
      _associations[index] = updatedAssociation;
    });
  }

  void _deleteAssociation(int index) async {
    int associationId = _associations[index].id!;
    await DatabaseHelper().deleteAssociation(associationId);

    setState(() {
      _associations.removeAt(index);
    });
  }


  void _startTimer(int index) async {
    Association association = _associations[index];

    if (association.timer == null) {
      if (association.startTime == null) {
        association.startTime = DateTime.now();
      } else if (association.pausedTime != null) {
        Duration pausedDuration = DateTime.now().difference(
            association.pausedTime!);
        association.startTime = association.startTime!.add(pausedDuration);
      }

      association.timer =
          Timer.periodic(Duration(seconds: 1), (Timer timer) async {
            if (association.startTime != null) {
              Duration elapsed = DateTime.now().difference(
                  association.startTime!);
              association.elapsedTime = _formatDuration(elapsed);

              await DatabaseHelper().updateAssociation(association.id!,
                  association); // تحديث قاعدة البيانات مع التقدم الزمني

              setState(() {});
            }
          });
    }
  }

  void _stopTimer(int index) async {
    Association association = _associations[index];

    if (association.timer != null) {
      association.timer!.cancel();
      association.timer = null;
      association.pausedTime = DateTime.now();

      await DatabaseHelper().updateAssociation(
          association.id!, association); // تحديث قاعدة البيانات مع وقت التوقف

      setState(() {});
    }
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(
        2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  @override
  void initState() {
    super.initState();
    _loadAssociations();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إدارة الجمعيات'),
      ),
      body: ListView.builder(
        itemCount: _associations.length,
        itemBuilder: (context, index) {
          Association association = _associations[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Text(
                association.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الأعضاء: ${association.members}'),
                  Text('الأيام: ${association.days}'),
                  Text('المبلغ: ${association.subscriptionAmount}'),
                  if (association.startTime != null)
                    Text('الوقت المنقضي: ${association.elapsedTime ?? 'غير متاح'}'),
                  if (association.remainingDays != null)
                    Text('الأيام المتبقية: ${association.remainingDays}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      association.timer == null ? Icons.timer_off : Icons.timer,
                      color: association.timer == null ? Colors.grey : Colors.blue,
                    ),
                    onPressed: () {
                      if (association.timer == null) {
                        _startTimer(index);
                      } else {
                        _stopTimer(index);
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _showAddAssociationDialog(
                          association: association, index: index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteAssociation(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAssociationDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


class AssociationInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('معلومات الجمعية'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200, // عرض الزر
              height: 60, // ارتفاع الزر
              child: ElevatedButton(
                onPressed: () => _showOptionsDialog(context, 'جمعية'),
                child: Text('جمعية', style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 20), // مسافة بين الزرين
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () => _showOptionsDialog(context, 'عضو'),
                child: Text('عضو', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool allSelected = false;
        bool oneSelected = false;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('اختر خيارًا'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: Text('الكل'),
                    value: allSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        allSelected = value!;
                        oneSelected = !value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('واحد فقط'),
                    value: oneSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        oneSelected = value!;
                        allSelected = !value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    String selectedOption = allSelected ? 'الكل' : 'واحد فقط';
                    _showSelectedOption(context, type, selectedOption);
                  },
                  child: Text('تأكيد'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('إلغاء'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSelectedOption(BuildContext context, String type, String option) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('الاختيار'),
          content: Text('لقد اخترت $option من $type'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('موافق'),
            ),
          ],
        );
      },
    );
  }
}



class DailyDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('عرض البيانات '),
      ),
      body: Center(
        child: Text('لاتوجد بيانات'),
      ),
    );
  }
}


class PaymentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المدفوعات'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () => _showAssociationDialog(context, 'ايداع'),
                child: Text('ايداع', style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                onPressed: () => _showAssociationDialog(context, 'نقدي'),
                child: Text('نقدي', style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(value: false, onChanged: (bool? value) {}),
                Text('اختار الكل', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 20),
            IconButton(
              icon: Icon(Icons.edit, size: 40),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _showAssociationDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('اختر الجمعية'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showOptionsDialog(context, type);
                },
                child: Text('جمعية 1'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showOptionsDialog(context, type);
                },
                child: Text('جمعية 2'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOptionsDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool allSelected = false;
        bool oneSelected = false;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('اختر خيارًا'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: Text('الكل'),
                    value: allSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        allSelected = value!;
                        oneSelected = !value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('واحد فقط'),
                    value: oneSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        oneSelected = value!;
                        allSelected = !value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    String selectedOption = allSelected ? 'الكل' : 'واحد فقط';
                    _showSelectedOption(context, type, selectedOption);
                  },
                  child: Text('تأكيد'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('إلغاء'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSelectedOption(BuildContext context, String type, String option) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('الاختيار'),
          content: Text('لقد اخترت $option من $type'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('موافق'),
            ),
          ],
        );
      },
    );
  }
}


class LoansPage extends StatefulWidget {
  @override
  _LoansPageState createState() => _LoansPageState();
}

class _LoansPageState extends State<LoansPage> {
  Map<String, Map<String, dynamic>> loans = {
    'سعيد محسن': {
      'amount': 8000,
      'color': Colors.red,
      'lent': 0,
      'owed': 8000,
      'transactions': [
        {
          'type': 'owed',
          'amount': 8000,
          'description': 'قرض أولي',
          'timestamp': DateTime.now(),
        },
      ],
    },
    'بسام سعيد': {
      'amount': 14500,
      'color': Colors.red,
      'lent': 0,
      'owed': 14500,
      'transactions': [
        {
          'type': 'owed',
          'amount': 14500,
          'description': 'قرض أولي',
          'timestamp': DateTime.now(),
        },
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    int totalAmount = loans.values.fold(0, (sum, loan) => sum + (loan['amount'] as int));

    return Scaffold(
      appBar: AppBar(
        title: Text('سلف من الجمية'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: loans.length,
              itemBuilder: (context, index) {
                String name = loans.keys.elementAt(index);
                return _buildListTile(
                  context,
                  name,
                  loans[name]!['amount'].toString(),
                  loans[name]!['color'],
                );
              },
            ),
          ),
          Container(
            color: Colors.blue,
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.help, color: Colors.white),
                Text('المجموع: $totalAmount', style: TextStyle(color: Colors.white)),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    _showAddLoanDialog(context, isNewName: true);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildListTile(BuildContext context, String name, String amount, Color color) {
    return ListTile(
      leading: Icon(Icons.arrow_downward, color: color),
      title: Text(name, style: TextStyle(color: color)),
      trailing: IconButton(
        icon: Icon(Icons.add, color: Colors.blue),
        onPressed: () {
          _showAddLoanDialog(context, name: name);
        },
      ),
      subtitle: Text(amount),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoanDetailsPage(name: name, loans: loans),
          ),
        );
      },
    );
  }

  void _showAddLoanDialog(BuildContext context, {String? name, bool isNewName = false}) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isNewName ? 'إضافة اسم جديد' : 'إضافة مبلغ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isNewName)
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'الاسم',
                    border: OutlineInputBorder(),
                  ),
                ),
              SizedBox(height: 10),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'المبلغ',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'التفاصيل',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton.icon(
              icon: Icon(Icons.arrow_upward, color: Colors.green),
              label: Text('له'),
              onPressed: () {
                setState(() {
                  String newName = isNewName ? nameController.text : name!;
                  int amount = int.parse(amountController.text);
                  String description = descriptionController.text;
                  DateTime timestamp = DateTime.now();
                  if (loans.containsKey(newName)) {
                    loans[newName]!['owed'] = (loans[newName]!['owed'] as int) - amount;
                    loans[newName]!['lent'] = (loans[newName]!['lent'] as int) + amount;
                    loans[newName]!['amount'] = (loans[newName]!['amount'] as int) - amount;
                    loans[newName]!['transactions'].add({
                      'type': 'lent',
                      'amount': amount,
                      'description': description,
                      'timestamp': timestamp,
                    });
                  } else {
                    loans[newName] = {
                      'amount': -amount,
                      'color': Colors.green,
                      'lent': amount,
                      'owed': 0,
                      'transactions': [
                        {
                          'type': 'lent',
                          'amount': amount,
                          'description': description,
                          'timestamp': timestamp,
                        },
                      ],
                    };
                  }
                });
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.arrow_downward, color: Colors.red),
              label: Text('عليه'),
              onPressed: () {
                setState(() {
                  String newName = isNewName ? nameController.text : name!;
                  int amount = int.parse(amountController.text);
                  String description = descriptionController.text;
                  DateTime timestamp = DateTime.now();
                  if (loans.containsKey(newName)) {
                    loans[newName]!['owed'] = (loans[newName]!['owed'] as int) + amount;
                    loans[newName]!['lent'] = (loans[newName]!['lent'] as int) - amount;
                    loans[newName]!['amount'] = (loans[newName]!['amount'] as int) + amount;
                    loans[newName]!['transactions'].add({
                      'type': 'owed',
                      'amount': amount,
                      'description': description,
                      'timestamp': timestamp,
                    });
                  } else {
                    loans[newName] = {
                      'amount': amount,
                      'color': Colors.red,
                      'lent': 0,
                      'owed': amount,
                      'transactions': [
                        {
                          'type': 'owed',
                          'amount': amount,
                          'description': description,
                          'timestamp': timestamp,
                        },
                      ],
                    };
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class LoanDetailsPage extends StatelessWidget {
  final String name;
  final Map<String, Map<String, dynamic>> loans;

  LoanDetailsPage({required this.name, required this.loans});

  @override
  Widget build(BuildContext context) {
    final loan = loans[name]!;

    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل القرض'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الاسم: $name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('المجموع: ${loan['amount']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            DataTable(
              columns: [
                DataColumn(label: Text('التاريخ')),
                DataColumn(label: Text('النوع')),
                DataColumn(label: Text('المبلغ')),
                DataColumn(label: Text('التفاصيل')),
              ],
              rows: loan['transactions'].map<DataRow>((transaction) {
                return DataRow(
                  cells: [
                    DataCell(Text(transaction['timestamp'].toString())),
                    DataCell(Text(transaction['type'] == 'lent' ? 'له' : 'عليه')),
                    DataCell(Text(transaction['amount'].toString())),
                    DataCell(Text(transaction['description'] ?? '')),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class RepayLoanPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('دفع السلفة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'الاسم',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'المبلغ',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'التفاصيل',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle saving data logic here
                print('Name: ${nameController.text}');
                print('Amount: ${amountController.text}');
                print('Description: ${descriptionController.text}');
              },
              child: Text('حفظ البيانات'),
            ),
          ],
        ),
      ),
    );
  }
}


class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('التقارير'),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildMonthButton(context, 'يناير'),
            _buildMonthButton(context, 'فبراير'),
            _buildMonthButton(context, 'مارس'),
            _buildMonthButton(context, 'أبريل'),
            _buildMonthButton(context, 'مايو'),
            _buildMonthButton(context, 'يونيو'),
            _buildMonthButton(context, 'يوليو'),
            _buildMonthButton(context, 'أغسطس'),
            _buildMonthButton(context, 'سبتمبر'),
            _buildMonthButton(context, 'أكتوبر'),
            _buildMonthButton(context, 'نوفمبر'),
            _buildMonthButton(context, 'ديسمبر'),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthButton(BuildContext context, String month) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 60, // ارتفاع الزر
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red, // خلفية حمراء
            onPrimary: Colors.white, // نص أبيض
          ),
          onPressed: () => _showReportTypeDialog(context, month),
          child: Text(
            month,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  void _showReportTypeDialog(BuildContext context, String month) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('اختر نوع التقرير لـ $month'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showAssociationDialog(context, 'جمعيات');
                },
                child: Text('جمعيات'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showAssociationDialog(context, 'شخصي');
                },
                child: Text('شخصي'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAssociationDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('اختر الجمعية/الشخص لعمل التقرير'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSelectedOption(context, type, 'جمعية 1');
                },
                child: Text('جمعية 1'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSelectedOption(context, type, 'جمعية 2');
                },
                child: Text('جمعية 2'),
              ),
              // أضف المزيد من الخيارات هنا حسب الحاجة
            ],
          ),
        );
      },
    );
  }

  void _showSelectedOption(BuildContext context, String type, String option) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('الاختيار'),
          content: Text('لقد اخترت $option من $type'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('موافق'),
            ),
          ],
        );
      },
    );
  }
}


class PersonalAccountPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController shareNumberController = TextEditingController();
  final TextEditingController associationNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController withdrawnAmountController = TextEditingController();
  final TextEditingController remainingAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الحساب الشخصي'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showRecipientsDialog(context),
                    icon: Icon(Icons.people), // أيقونة للمستلمين
                    label: Text('زر المستلمين'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showGuaranteeContractDialog(context),
                    icon: Icon(Icons.document_scanner), // أيقونة لعقد الضمانة
                    label: Text('عقد الضمانة'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showMemberDataDialog(context),
                    icon: Icon(Icons.person), // أيقونة لبيانات العضو
                    label: Text('بيانات العضو'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showRecipientsDialog(BuildContext context) {
    // الحصول على التاريخ والوقت الحاليين
    String currentDate = DateTime.now().toLocal().toString().split(
        ' ')[0]; // YYYY-MM-DD

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('بيانات المستلمين'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField('الاسم', nameController),
                _buildTextField('المبلغ', amountController),
                _buildTextField('رقم السهم', shareNumberController),
                _buildTextField('اسم الجمعية', associationNameController),
                TextField(
                  controller: dateController..text = currentDate,
                  // تعيين التاريخ الحالي
                  decoration: InputDecoration(
                    labelText: 'التاريخ',
                  ),
                  readOnly: true, // اجعل الحقل غير قابل للتعديل
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // قم بحفظ البيانات هنا
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecipientsDetailsPage(
                              recipientsData: [
                                {
                                  'name': nameController.text,
                                  'amount': amountController.text,
                                  'shareNumber': shareNumberController.text,
                                  'associationName': associationNameController
                                      .text,
                                  'date': dateController.text,
                                },
                              ],
                            ),
                      ),
                    );
                  },
                  child: Text('حفظ البيانات'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }


  void _showGuaranteeContractDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('عقد الضمانة'),
          content: Text('محتوى عقد الضمانة هنا'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }

  void _showMemberDataDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RecipientsDetailsPage1(
              name: '', loans: {},
            ),
      ),
    );
  }
}

class SendReportPage extends StatelessWidget {
  final TextEditingController _messageController = TextEditingController();

  // Function to send message via WhatsApp
  Future<void> _sendMessage(String phoneNumber, String message) async {
    final url = 'whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter the message to send:'),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your message here...',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String phoneNumber = '+1234567890'; // استبدل برقم الهاتف الذي تريد الإرسال إليه
                _sendMessage(phoneNumber, _messageController.text);
              },
              child: Text('Send via WhatsApp'),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipientsDetailsPage extends StatefulWidget {
  final List<Map<String, String>> recipientsData;

  RecipientsDetailsPage({required this.recipientsData});

  @override
  _RecipientsDetailsPageState createState() => _RecipientsDetailsPageState();
}

class _RecipientsDetailsPageState extends State<RecipientsDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل المستلمين'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.recipientsData.length,
        itemBuilder: (context, index) {
          final data = widget.recipientsData[index];
          return ListTile(
            title: Text('${data['name']} - ${data['amount']}'),
            subtitle: Text('رقم السهم: ${data['shareNumber']}, الجمعية: ${data['associationName']}, التاريخ: ${data['date']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showEditDialog(context, index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteData(context, index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    // الحصول على التاريخ والوقت الحاليين
    String currentDate = DateTime.now().toLocal().toString().split(' ')[0]; // YYYY-MM-DD

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('إضافة بيانات جديدة'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField('الاسم'),
                _buildTextField('المبلغ'),
                _buildTextField('رقم السهم'),
                _buildTextField('اسم الجمعية'),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'التاريخ',
                  ),
                  controller: TextEditingController()..text = currentDate,
                  readOnly: true, // اجعل الحقل غير قابل للتعديل
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // أضف البيانات الجديدة هنا
                    Navigator.pop(context);
                  },
                  child: Text('حفظ البيانات'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, int index) {
    // هنا يمكنك تنفيذ دالة التعديل حسب الحاجة
  }

  void _deleteData(BuildContext context, int index) {
    setState(() {
      widget.recipientsData.removeAt(index);
    });
  }

  Widget _buildTextField(String labelText) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }
}



class  RecipientsDetailsPage1  extends StatelessWidget {
  final String name;
  final Map<String, Map<String, dynamic>> loans;

RecipientsDetailsPage1 ({required this.name, required this.loans});

  @override
  Widget build(BuildContext context) {
    final loan = loans[name];

    if (loan == null) {
      // إذا كان القرض غير موجود، اعرض رسالة خطأ أو واجهة فارغة.
      return Scaffold(
        appBar: AppBar(
          title: Text('تفاصيل القرض'),
        ),
        body: Center(
          child: Text('القرض غير موجود'),
        ),
      );
    }

    final transactions = loan['transactions'] as List<Map<String, dynamic>>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل القرض'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 4)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الاسم: $name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('المجموع: ${loan['amount'] ?? 0}', style: TextStyle(fontSize: 18, color: Colors.blue)),
                  SizedBox(height: 8),
                  Text('المبالغ المقرضة: ${loan['lent'] ?? 0}', style: TextStyle(fontSize: 16, color: Colors.green)),
                  SizedBox(height: 8),
                  Text('المبالغ المتبقية: ${loan['owed'] ?? 0}', style: TextStyle(fontSize: 16, color: Colors.red)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('التاريخ')),
                    DataColumn(label: Text('النوع')),
                    DataColumn(label: Text('المبلغ')),
                    DataColumn(label: Text('التفاصيل')),
                  ],
                  rows: transactions.map<DataRow>((transaction) {
                    return DataRow(
                      cells: [
                        DataCell(Text(_formatDate(transaction['timestamp'] as DateTime))),
                        DataCell(Text(transaction['type'] == 'lent' ? 'له' : 'عليه')),
                        DataCell(Text(transaction['amount'].toString())),
                        DataCell(Text(transaction['description'] ?? '')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('إضافة عملية'),
                  onPressed: () {
                    // وظيفة لإضافة عملية جديدة
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.delete, color: Colors.white),
                  label: Text('حذف عملية'),
                  onPressed: () {
                    // وظيفة لحذف عملية
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}-${dateTime.month}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }
}


