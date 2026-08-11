import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

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

  // Formatear la fecha y hora completa en español
  String _formatDateTime(String? dateIsoString) {
    if (dateIsoString == null) return 'Hoy';
    try {
      final dateTime = DateTime.parse(dateIsoString).toLocal();
      final day = dateTime.day.toString().padLeft(2, '0');
      final month = dateTime.month.toString().padLeft(2, '0');
      final year = dateTime.year;
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$day/$month/$year - $hour:$minute';
    } catch (_) {
      return dateIsoString;
    }
  }

  // Diálogo de confirmación para eliminar un quiz
  void _confirmDelete(BuildContext context, String sessionId, String userName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
            SizedBox(width: 10),
            Text('¿Eliminar evaluación?', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar permanentemente el registro del quiz de "$userName"? Esta acción no se puede deshacer.',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await SupabaseService.deleteQuizSession(sessionId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Registro eliminado con éxito.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al eliminar: $e'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
            },
            child: const Text('Sí, eliminar'),
          ),
        ],
      ),
    );
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
                // PANEL DE TARJETAS DE MÉTRICAS
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

                // LISTA DE EVALUACIONES CON FECHA/HORA Y BOTÓN DE BORRADO
                Expanded(
                  child: ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      final sessionId = session['id'].toString();
                      final profilesTable = session['profiles'] as Map<String, dynamic>?;
                      final userName = profilesTable?['full_name'] ?? 'Usuario / Invitado';
                      final profileName = session['final_profile'] ?? 'Reactivo/a';
                      final profileColor = _getProfileColor(profileName);
                      final formattedDate = _formatDateTime(session['completed_at']?.toString());

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
                              Expanded(
                                child: Text(
                                  userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ejes MIL ➔ Verificación: ${session['score_v']} | Emoción: ${session['score_e']} | IA: ${session['score_a']} | Creación: ${session['score_c']}',
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 13, color: Color(0xFF38BDF8)),
                                    const SizedBox(width: 4),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            tooltip: 'Eliminar Registro',
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => _confirmDelete(context, sessionId, userName),
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