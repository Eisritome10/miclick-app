import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  final String initialLanguage;

  const AdminDashboardScreen({
    super.key,
    this.initialLanguage = 'en',
  });

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.initialLanguage;
  }

  // Traducciones del Admin Dashboard
  String _t(String key) {
    final isEn = _selectedLanguage == 'en';
    switch (key) {
      case 'title':
        return 'MiClick Dashboard - Admin Control';
      case 'logout':
        return isEn ? 'Logout' : 'Cerrar Sesión';
      case 'total_eval':
        return isEn ? 'Total Evaluated' : 'Total Evaluados';
      case 'avg_v':
        return isEn ? 'Avg Verification (V)' : 'Prom. Verificación (V)';
      case 'top_profile':
        return isEn ? 'Top Digital Persona' : 'Perfil Predominante';
      case 'live_log':
        return isEn
            ? 'Real-Time Evaluation Log ⚡'
            : 'Registro de Evaluaciones en Tiempo Real ⚡';
      case 'live_badge':
        return isEn ? 'Live Stream' : 'En Vivo';
      case 'no_data':
        return isEn
            ? 'No completed quiz records found yet.'
            : 'Aún no hay registros de quizzes completados.';
      case 'user_guest':
        return isEn ? 'User / Guest' : 'Usuario / Invitado';
      case 'scores_label':
        return isEn
            ? 'MIL Axes ➔ Verification: '
            : 'Ejes MIL ➔ Verificación: ';
      case 'delete_tooltip':
        return isEn ? 'Delete Record' : 'Eliminar Registro';
      case 'delete_title':
        return isEn ? 'Delete evaluation?' : '¿Eliminar evaluación?';
      case 'delete_confirm':
        return isEn
            ? 'Are you sure you want to permanently delete the quiz record? This action cannot be undone.'
            : '¿Estás seguro de que deseas eliminar permanentemente el registro del quiz? Esta acción no se puede deshacer.';
      case 'cancel':
        return isEn ? 'Cancel' : 'Cancelar';
      case 'yes_delete':
        return isEn ? 'Yes, delete' : 'Sí, eliminar';
      case 'delete_success':
        return isEn
            ? 'Record deleted successfully.'
            : 'Registro eliminado con éxito.';
      case 'delete_error':
        return isEn ? 'Error deleting record: ' : 'Error al eliminar: ';
      default:
        return key;
    }
  }

  // Traducir los nombres de perfiles en las métricas
  String _translateProfileName(String profile) {
    if (_selectedLanguage != 'en') return profile;
    switch (profile) {
      case 'Investigador/a':
        return 'The Researcher';
      case 'Empático/a Crítico/a':
        return 'The Critical Empath';
      case 'Confirmador/a':
        return 'The Confirmator';
      case 'Ingenuo/a Digital':
        return 'The Digital Naïve';
      case 'Amplificador/a':
        return 'The Amplifier';
      case 'Reactivo/a':
        return 'The Reactive';
      default:
        return profile;
    }
  }

  Color _getProfileColor(String profile) {
    switch (profile) {
      case 'Investigador/a':
      case 'The Researcher':
        return Colors.greenAccent;
      case 'Empático/a Crítico/a':
      case 'The Critical Empath':
        return const Color(0xFF38BDF8);
      case 'Confirmador/a':
      case 'The Confirmator':
        return Colors.amberAccent;
      case 'Ingenuo/a Digital':
      case 'The Digital Naïve':
        return Colors.orangeAccent;
      case 'Amplificador/a':
      case 'The Amplifier':
        return Colors.redAccent;
      default:
        return Colors.purpleAccent; // Reactivo/a
    }
  }

  String _formatDateTime(String? dateIsoString) {
    if (dateIsoString == null) return _selectedLanguage == 'en' ? 'Today' : 'Hoy';
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

  void _confirmDelete(BuildContext context, String sessionId, String userName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
            const SizedBox(width: 10),
            Text(_t('delete_title'),
                style: const TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: Text(
          '${_t('delete_confirm')} ("$userName")',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(_t('cancel'), style: const TextStyle(color: Colors.white60)),
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
                    SnackBar(
                      content: Text(_t('delete_success')),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${_t('delete_error')}$e'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
            },
            child: Text(_t('yes_delete')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEn = _selectedLanguage == 'en';

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text(_t('title')),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          // SELECTOR DE IDIOMA EN EL APP BAR DE ADMIN
          Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                setState(() {
                  _selectedLanguage = _selectedLanguage == 'en' ? 'es' : 'en';
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF38BDF8), width: 1.5),
                ),
                child: Text(
                  isEn ? '🇬🇧 English' : '🇵🇪 Español',
                  style: const TextStyle(
                    color: Color(0xFF38BDF8),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: _t('logout'),
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
                'Error connecting to Supabase: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          final sessions = snapshot.data ?? [];

          if (sessions.isEmpty) {
            return Center(
              child: Text(
                _t('no_data'),
                style: const TextStyle(color: Colors.white70, fontSize: 16),
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

          String topProfileRaw = 'N/A';
          int maxCount = 0;
          profileCounts.forEach((key, value) {
            if (value > maxCount) {
              maxCount = value;
              topProfileRaw = key;
            }
          });

          final topProfileDisplay = _translateProfileName(topProfileRaw);

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PANEL DE TARJETAS DE MÉTRICAS
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildMetricCard(
                      _t('total_eval'),
                      '${sessions.length}',
                      Icons.people,
                      const Color(0xFF38BDF8),
                    ),
                    _buildMetricCard(
                      _t('avg_v'),
                      '${avgV.toStringAsFixed(1)} / 18',
                      Icons.verified_user,
                      Colors.greenAccent,
                    ),
                    _buildMetricCard(
                      _t('top_profile'),
                      topProfileDisplay,
                      Icons.analytics,
                      _getProfileColor(topProfileDisplay),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _t('live_log'),
                      style: const TextStyle(
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
                      child: Text(
                        _t('live_badge'),
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // LISTA DE EVALUACIONES
                Expanded(
                  child: ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      final sessionId = session['id'].toString();
                      final profilesTable =
                          session['profiles'] as Map<String, dynamic>?;
                      final userName = profilesTable?['full_name'] ?? _t('user_guest');
                      final rawProfile = session['final_profile'] ?? 'Reactivo/a';
                      final profileDisplay = _translateProfileName(rawProfile);
                      final profileColor = _getProfileColor(profileDisplay);
                      final formattedDate =
                          _formatDateTime(session['completed_at']?.toString());

                      return Card(
                        color: const Color(0xFF1E293B),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(color: Colors.white10),
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: profileColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: profileColor.withOpacity(0.5)),
                                ),
                                child: Text(
                                  profileDisplay,
                                  style: TextStyle(
                                    color: profileColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                  isEn
                                      ? 'MIL Axes ➔ V: ${session['score_v']} | E: ${session['score_e']} | A: ${session['score_a']} | C: ${session['score_c']}'
                                      : 'Ejes MIL ➔ V: ${session['score_v']} | E: ${session['score_e']} | A: ${session['score_a']} | C: ${session['score_c']}',
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time,
                                        size: 13, color: Color(0xFF38BDF8)),
                                    const SizedBox(width: 4),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        color: Color(0xFF38BDF8),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            tooltip: _t('delete_tooltip'),
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            onPressed: () =>
                                _confirmDelete(context, sessionId, userName),
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

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
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
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
                color: color, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}