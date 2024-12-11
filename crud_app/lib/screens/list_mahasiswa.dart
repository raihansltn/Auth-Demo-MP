import 'package:flutter/material.dart';
import 'form_mahasiswa.dart';
import 'package:crud_app/models/mahasiswa_model.dart';
import 'package:crud_app/services/mahasiswa_services.dart';

class ListMahasiswaPage extends StatefulWidget {
  const ListMahasiswaPage({super.key});

  @override
  _ListMahasiswaPageState createState() => _ListMahasiswaPageState();
}

class _ListMahasiswaPageState extends State<ListMahasiswaPage> {
  List<Mahasiswa> _mahasiswas = [];

  @override
  void initState() {
    super.initState();
    _fetchMahasiswas();
  }

  Future<void> _fetchMahasiswas() async {
    final mahasiswas = await MahasiswaService.readMahasiswa();
    setState(() {
      _mahasiswas = mahasiswas;
    });
  }

  void _confirmDelete(Mahasiswa mahasiswa) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Konfirmasi Hapus'),
              content: Text(
                  'Apakah anda yakin ingin menghapus mahasiswa ${mahasiswa.nama}?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal')),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    try {
                      String message =
                          await MahasiswaService.deleteMahasiswa(mahasiswa.id!);
                      _fetchMahasiswas();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal menghapus $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Hapus'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Mahasiswa'), actions: [
        IconButton(onPressed: _fetchMahasiswas, icon: const Icon(Icons.refresh))
      ]),
      body: ListView.builder(
        itemCount: _mahasiswas.length,
        itemBuilder: (context, index) {
          final mahasiswa = _mahasiswas[index];
          return ListTile(
            title: Text(mahasiswa.nama),
            subtitle: Text('NIM: ${mahasiswa.nim} | ${mahasiswa.prodi}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FormMahasiswa(mahasiswa: mahasiswa)))
                          .then((_) => _fetchMahasiswas());
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                    )),
                IconButton(
                    onPressed: () => _confirmDelete(mahasiswa),
                    icon: const Icon(
                      Icons.delete,
                      color: Color.fromARGB(255, 0, 11, 110),
                    ))
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FormMahasiswa()))
              .then((_) => _fetchMahasiswas());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
