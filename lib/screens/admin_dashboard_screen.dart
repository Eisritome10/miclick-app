import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Fondo Oscuro
      appBar: AppBar(
        title: const Text('Dashboard MiClick - Control en Tiempo Real'),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SupabaseService.client.auth.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: SupabaseService.getRealtimeQuizSessions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar métricas: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          final sessions = snapshot.data ?? [];

          if (sessions.isEmpty) {
            return const Center(
              child: Text(
                'Aún no hay usuarios que hayan completado el quiz.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tarjeta de resumen de métricas
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard('Total Evaluados', '${sessions.length}', const Color(0xFF38BDF8)),
                      _buildStatCard('Sincronización', 'Tiempo Real ⚡', Colors.greenAccent),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Registro de Evaluaciones Recientes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                // Lista en tiempo real de registros
                Expanded(
                  child: ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      return Card(
                        color: const Color(0xFF1E293B),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.white10),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF38BDF8),
                            child: Icon(Icons.person, color: Colors.black),
                          ),
                          title: Text(
                            'Perfil: ${session['final_profile']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Puntajes MIL ➔ Verificación: ${session['score_v']} | Emoción: ${session['score_e']} | Algoritmo: ${session['score_a']} | Creación: ${session['score_c']}',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          trailing: Text(
                            session['completed_at'] != null 
                                ? session['completed_at'].toString().substring(0, 10) 
                                : '',
                            style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 12),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white60, fontSize: 14)),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}