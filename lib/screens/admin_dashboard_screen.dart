import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  // Color de etiqueta según el perfil
  Color _getProfileColor(String profile) {
    switch (profile) {
      case 'Investigador/a':
        return Colors.greenAccent;
      case 'Empático/a Crítico/a':
        return const Color(0xFF38BDF8);
      case 'Confirmador/a':
        return Colors.amberAccent;
      case 'Ingenuo/a Digital':
        return Colors.orangeAccent;
      case 'Amplificador/a':
        return Colors.redAccent;
      default:
        return Colors.purpleAccent; // Reactivo/a
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Dashboard MiClick - Control Admin'),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Cerrar Sesión',
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
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al conectar con Supabase: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          final sessions = snapshot.data ?? [];

          if (sessions.isEmpty) {
            return const Center(
              child: Text(
                'Aún no hay registros de quizzes completados.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          // CÁLCULO DE MÉTRICAS GLOBALES
          double totalScoreV = 0;
          final Map<String, int> profileCounts = {};

          for (var s in sessions) {
            totalScoreV += (s['score_v'] ?? 0);
            final String prof = s['final_profile'] ?? 'Reactivo/a';
            profileCounts[prof] = (profileCounts[prof] ?? 0) + 1;
          }

          final double avgV = sessions.isNotEmpty ? (totalScoreV / sessions.length) : 0;
          
          String topProfile = 'N/A';
          int maxCount = 0;
          profileCounts.forEach((key, value) {
            if (value > maxCount) {
              maxCount = value;
              topProfile = key;
            }
          });

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PANEL DE TARJETAS DE MÉTRICAS (KPIs)
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildMetricCard(
                          'Total Evaluados',
                          '${sessions.length}',
                          Icons.people,
                          const Color(0xFF38BDF8),
                        ),
                        _buildMetricCard(
                          'Prom. Verificación (V)',
                          avgV.toStringAsFixed(1),
                          Icons.verified_user,
                          Colors.greenAccent,
                        ),
                        _buildMetricCard(
                          'Perfil Predominante',
                          topProfile,
                          Icons.analytics,
                          _getProfileColor(topProfile),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Registro de Evaluaciones en Tiempo Real ⚡',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.greenAccent),
                      ),
                      child: const Text(
                        'En Vivo',
                        style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // LISTA EN TIEMPO REAL DE USUARIOS Y SUS RESULTADOS MIL
                Expanded(
                  child: ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      final profilesTable = session['profiles'] as Map<String, dynamic>?;
                      final userName = profilesTable?['full_name'] ?? 'Usuario / Invitado';
                      final profileName = session['final_profile'] ?? 'Reactivo/a';
                      final profileColor = _getProfileColor(profileName);

                      final dateStr = session['completed_at'] != null
                          ? session['completed_at'].toString().substring(0, 10)
                          : 'Hoy';

                      return Card(
                        color: const Color(0xFF1E293B),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(color: Colors.white10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: profileColor.withOpacity(0.2),
                            child: Icon(Icons.person, color: profileColor),
                          ),
                          title: Row(
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: profileColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: profileColor.withOpacity(0.5)),
                                ),
                                child: Text(
                                  profileName,
                                  style: TextStyle(color: profileColor, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              'Ejes MIL ➔ Verificación: ${session['score_v']} | Emoción: ${session['score_e']} | IA/Algoritmo: ${session['score_a']} | Creación: ${session['score_c']}',
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ),
                          trailing: Text(
                            dateStr,
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

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white60, fontSize: 13)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}