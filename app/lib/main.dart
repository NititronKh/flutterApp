import 'package:flutter/material.dart';
import 'mock_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLogin = true;

  void toggleView() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void authenticate() {
    // ตัวอย่างข้อมูลผู้ใช้ที่ลงทะเบียนไว้
    const registeredUsers = {
      'king@mail.com': 'king090745', // แอดมิน
      'user@example.com': 'password123', // ผู้ใช้ทั่วไป
    };

    if (isLogin) {
      // เข้าสู่ระบบ
      if (registeredUsers[emailController.text] == passwordController.text) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CoffeeMenuPage(email: emailController.text),
          ),
        );
      } else {
        // แจ้งเตือนเมื่อรหัสผ่านไม่ถูกต้อง
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('เข้าสู่ระบบล้มเหลว'),
            content: Text('อีเมลหรือรหัสผ่านไม่ถูกต้อง'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ตกลง'),
              ),
            ],
          ),
        );
      }
    } else {
      // สมัครสมาชิก
      print("สมัครสมาชิกด้วยอีเมล: ${emailController.text}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CoffeeMenuPage(email: emailController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'เข้าสู่ระบบ' : 'สมัครสมาชิก'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'อีเมล'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'รหัสผ่าน'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: authenticate,
              child: Text(isLogin ? 'เข้าสู่ระบบ' : 'สมัครสมาชิก'),
            ),
            TextButton(
              onPressed: toggleView,
              child: Text(isLogin ? 'ยังไม่มีบัญชี? สมัครสมาชิก' : 'มีบัญชีอยู่แล้ว? เข้าสู่ระบบ'),
            ),
          ],
        ),
      ),
    );
  }
}

class CoffeeMenuPage extends StatefulWidget {
  final String email; // รับอีเมลจากหน้าลงชื่อเข้าใช้

  CoffeeMenuPage({required this.email});

  @override
  _CoffeeMenuPageState createState() => _CoffeeMenuPageState();
}

class _CoffeeMenuPageState extends State<CoffeeMenuPage> {
  final TextEditingController coffeeNameController = TextEditingController();
  final TextEditingController coffeeDescriptionController = TextEditingController();

  void addCoffee() {
    final String name = coffeeNameController.text;
    final String description = coffeeDescriptionController.text;

    if (widget.email == 'king@mail.com') { // เช็คว่าเป็นแอดมิน
      if (name.isNotEmpty && description.isNotEmpty) {
        setState(() {
          mockCoffees.add(Coffee(id: (mockCoffees.length + 1).toString(), name: name, description: description));
          coffeeNameController.clear();
          coffeeDescriptionController.clear();
        });
      }
    } else {
      // แจ้งเตือนว่าไม่สามารถเพิ่มได้
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('การเข้าถึงถูกจำกัด'),
          content: Text('คุณต้องเป็นแอดมินเพื่อเพิ่มกาแฟ'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('ตกลง'),
            ),
          ],
        ),
      );
    }
  }

  void deleteCoffee(String id) {
    setState(() {
      mockCoffees.removeWhere((coffee) => coffee.id == id);
    });
  }

  void logout() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เมนูกาแฟ'),
      ),
      body: Column(
        children: [
          if (widget.email == 'king@mail.com') ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: coffeeNameController,
                decoration: InputDecoration(labelText: 'ชื่อกาแฟ'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: coffeeDescriptionController,
                decoration: InputDecoration(labelText: 'รายละเอียดกาแฟ'),
              ),
            ),
            ElevatedButton(
              onPressed: addCoffee,
              child: Text('เพิ่มกาแฟ'),
            ),
          ],
          Expanded(
            child: ListView.builder(
              itemCount: mockCoffees.length,
              itemBuilder: (context, index) {
                final coffee = mockCoffees[index];
                return ListTile(
                  title: Text(coffee.name),
                  subtitle: Text(coffee.description),
                  trailing: widget.email == 'king@mail.com'
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteCoffee(coffee.id),
                        )
                      : null, // ไม่แสดงปุ่มลบถ้าไม่ใช่แอดมิน
                );
              },
            ),
          ),
          SizedBox(height: 20), // ช่องว่าง
          ElevatedButton(
            onPressed: logout,
            child: Text('ออกจากระบบ'),
          ),
          SizedBox(height: 20), // ช่องว่าง
          if (widget.email == 'king@mail.com') // แสดงอีเมลผู้ใช้ทั้งหมดถ้าเป็นแอดมิน
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ผู้ใช้ที่ลงทะเบียน:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...mockUsers.map((user) => Text(user)).toList(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
