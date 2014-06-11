import java.util.*;
import java.sql.*;
import java.io.*;
import java.util.Locale;

public class SibenchClient extends Common implements Runnable
{
	public static int THREADS = 10;
	public static int duration = 0;
	public static int warmup = 0;
	public static boolean is_running = true;
	public static boolean measuring = false;

	public int ri_abort = 0 ;
	public int ri_succ = 0 ;

	public int r_abort = 0 ;
	public int r_succ = 0 ;

	public int ru_abort = 0 ;
	public int ru_succ = 0 ;

	public static long[] r_times ;
	public static long[] w_times ;
	public static long[] u_times ;

	public static long[] r_c_times ;
	public static long[] w_c_times ;
	public static long[] u_c_times ;

	public static int R_WEIGHT = 0;
	public static int RW_WEIGHT = 0;

	public static int NUMOFROWS = 0;
	public static int NUMOFROWSTOREAD = 0;
	public static int NUMOFROWSTOUPDATE = 0;

	public static int TOTAL_WEIGHT = 0;

	public static String[] table_pf = { "0", "1", "2"};

	Connection conn ;
	Statement stmt ;

	int th_id = 0;

	public static boolean MI_SSI = false;
	public static boolean MI_SI = false;
	public static boolean MI_S2PL = false;

	public SibenchClient( int b )
	{ 
		th_id = b;

		//init stat variables
		r_times[th_id] = 0;
		w_times[th_id] = 0;
		u_times[th_id] = 0;
		r_c_times[th_id] = 0;
		w_c_times[th_id] = 0;
		u_c_times[th_id] = 0;

	}

	public void run()
	{
		try
		{
			generate();
		}
		catch ( Exception e )
		{
			e.printStackTrace();
			System.exit ( 0 );
		}
	}
	public void init()  throws Exception
	{
		conn = getDBConnection();
		stmt = conn.createStatement();
		// if ( MI_SSI ) stmt.executeUpdate( "SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE SNAPSHOT" );
		// else if ( MI_SI ) stmt.executeUpdate( "SET SESSION TRANSACTION ISOLATION LEVEL SNAPSHOT" );
		// else if ( MI_S2PL ) stmt.executeUpdate( "SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE" );
		stmt.executeUpdate( "SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE" );
		stmt.executeUpdate( "SET AUTOCOMMIT = 0" );
		conn.setAutoCommit( false );
	}

	public int getTxType( int we )
	{
		if ( we < R_WEIGHT ) return 1;
		else return 2;
	}

	public void generate() throws Exception
	{
		Random r = new Random( System.currentTimeMillis() );

		int max_key = NUMOFROWS - NUMOFROWSTOREAD;

		while( is_running )
		{
			int tx_type = r.nextInt( TOTAL_WEIGHT );
			int up_type = 0;
			long t_a, t_b, t_c;
			int table ;

			long total_time,commit_time ;

			try
			{

				t_a =  System.currentTimeMillis();
				StringBuffer buf = new StringBuffer();

				buf = new StringBuffer();

				int rand_num = -1;
				if ( max_key != 0 )
					rand_num = r.nextInt( max_key );

				table = r.nextInt( 3 );
				buf = new StringBuffer();
				buf.append( "SELECT sum( b_int) FROM sibench" + table_pf[table] +" where b_key > ");
				buf.append( rand_num );
				buf.append( " and b_key <= " );
				buf.append( (rand_num+ NUMOFROWSTOREAD) );

				ResultSet rs = stmt.executeQuery( buf.toString() );
				while (rs.next()) {}

				if ( !(tx_type < R_WEIGHT )) //update trx
				{
					table = (table+1)%3;

					buf = new StringBuffer();

					int b_value = r.nextInt( 10 ); // choose a char attribute randomly
					buf.append( "UPDATE sibench"+table_pf[table] +" SET b_value" ).append( b_value ).append ( " = '" );
					buf.append( getString( 51,r) ); // make 51-byte string
					buf.append( "' where " );
					for( int m = 0 ; m < NUMOFROWSTOUPDATE ; m++ )
					{
						buf.append( "b_key = " );
						buf.append( r.nextInt( NUMOFROWS ) );
						if ( m  < NUMOFROWSTOUPDATE - 1 ) buf.append( " or " );
					}
					buf.append( "; " );
					stmt.executeUpdate( buf.toString() );

				}

				t_b =  System.currentTimeMillis();
				conn.commit();
				t_c =  System.currentTimeMillis();

				total_time = t_c - t_a;
				commit_time = t_c - t_b;

				if ( measuring )
				{
					if ( tx_type < R_WEIGHT )
					{
						r_succ++;
						r_times[th_id] += total_time;
						r_c_times[th_id] += commit_time;
					}
					else 
					{
						ru_succ++;
						u_times[th_id] += total_time;
						u_c_times[th_id] += commit_time;
					}
				}
			}
			catch ( Exception e )
			{
				try
				{
					conn.rollback();
				}
				catch ( Exception e2 )
				{
					e2.printStackTrace();
					System.exit( 0 );
					throw e2;
				}
				
				if ( measuring )
				{
					if ( tx_type < R_WEIGHT )
						r_abort++;
					else 
						ru_abort++;
				}
			}
		}
		try
		{
			conn.close();
		}
		catch ( Exception ex )
		{
		}
	}

	public static void main(String[] args ) throws Exception
	{
		Locale.setDefault( Locale.US ); // point instead of comma separator

		// handle args
		THREADS 	= Integer.parseInt( args[0] );
		R_WEIGHT 	= Integer.parseInt( args[1] );
		RW_WEIGHT 	= Integer.parseInt( args[2] );

		String iso_level = args[3];

		if ( iso_level.startsWith( "SSI" ) ) MI_SSI = true;
		else if ( iso_level.startsWith( "SI" ) ) MI_SI = true;
		else if ( iso_level.startsWith( "S2PL" ) ) MI_S2PL = true;
		
		duration = Integer.parseInt( props.getProperty ( "EXP.Duration" , "60" ) );
		if(args.length > 3)
			duration = Integer.parseInt( args[4] );
		
		// derive other variables
		TOTAL_WEIGHT = R_WEIGHT + RW_WEIGHT;

		NUMOFROWS  = Integer.parseInt( props.getProperty ( "DB.TableSize" , "100000" ) );
		NUMOFROWSTOREAD  = Integer.parseInt( props.getProperty ( "EXP.NumOfRowRead" , "100" ) );
		NUMOFROWSTOUPDATE = Integer.parseInt( props.getProperty ( "EXP.NumOfRowUpdate" , "20" ) );

		warmup = Integer.parseInt( props.getProperty ( "EXP.WarmUp" , "10" ) );
		
		System.out.printf("THREADS:   %d\n", THREADS);
		System.out.printf("R_WEIGHT:  %d%% reads\n", 100*R_WEIGHT/TOTAL_WEIGHT);
		System.out.printf("RW_WEIGHT: %d%% updates\n", 100*RW_WEIGHT/TOTAL_WEIGHT);
		System.out.printf("duration:  %ds\n", duration);
		System.out.printf("warmup:    %ds\n", warmup);


		Thread[] worker = new Thread[THREADS];
		SibenchClient[] gen = new SibenchClient[THREADS];
		r_times = new long[THREADS];
		w_times = new long[THREADS];
		u_times = new long[THREADS];
		r_c_times = new long[THREADS];
		w_c_times = new long[THREADS];
		u_c_times = new long[THREADS];

		Thread th = new Thread( new KillThread() );
		th.start();

		for( int i = 0 ; i < THREADS ; i++ )
		{
			gen[i] = new SibenchClient( i );
			gen[i].init();
			worker[i] = new Thread( gen[i] );
		}

		for( int i = 0 ; i < worker.length ; i++ )
			worker[i].start();

		Thread.currentThread().sleep( 1000*warmup ); //warm up
		measuring = true;
		System.out.println("Warmup phase elapsed, measuring");
		Thread.currentThread().sleep( 1000*duration ); //measuring period is a time of 60 seconds.
		is_running =false;

		int r_t_succ = 0;
		int r_t_fail = 0;
		int ru_t_succ = 0;
		int ru_t_fail = 0;

		long r_t_tot_time = 0;
		long r_t_com_time = 0;
		long ru_t_tot_time = 0;
		long ru_t_com_time = 0;

		long r_t_ea = 0;
		long ru_t_ea = 0;

		//make summary stats
		Stats totalStats = new Stats();
		for( int i = 0 ; i < worker.length ; i++ )
		{
			r_t_succ = r_t_succ + gen[i].r_succ;
			r_t_fail = r_t_fail + gen[i].r_abort;
			ru_t_succ = ru_t_succ + gen[i].ru_succ;
			ru_t_fail = ru_t_fail + gen[i].ru_abort;

			r_t_tot_time  += r_times[i];
			ru_t_tot_time += u_times[i];

			r_t_com_time  += r_c_times[i];
			ru_t_com_time += u_c_times[i];

			totalStats.addValue(getOpsPerTime(gen[i].r_succ + gen[i].ru_succ, r_times[i] + u_times[i]));
		}
		
		System.out.println();
		
		System.out.printf( "READ_Trx (succ/fail)   %d/%d\n", r_t_succ, r_t_fail );
		System.out.printf( "READ_total_time        %d\n", r_t_tot_time );
		System.out.printf( "RU_Trx (succ/fail)     %d/%d\n", ru_t_succ, ru_t_fail );
		System.out.printf( "RU_total_time          %d\n", ru_t_tot_time );
		System.out.printf( "TOTAL_Trx (succ/fail)  %d/%d\n", r_t_succ + ru_t_succ , r_t_fail + ru_t_fail);
		System.out.println();
		System.out.printf( "Total transactions:    %.4f tx/ms\n", totalStats.getExpectedValue() );
		System.out.printf( "Standard deviation:    %.4f\n", totalStats.getStandardDeviation() );
		
		System.out.println();
		
		System.out.printf( "AVG_READ_TX_TIME       %.2f ms/read tx\n", getAvgTime( r_t_tot_time , r_t_succ ) );
		System.out.printf( "AVG_READ_COMMIT_TIME   %.2f ms/read commit\n", getAvgTime( r_t_com_time , r_t_succ ) );
		System.out.printf( "AVG_READ_TX_PER_MS     %.2f read tx/ms\n", getOpsPerTime( r_t_succ, r_t_tot_time ) );
		
		System.out.printf( "AVG_RU_TX_TIME         %.2f ms/update tx\n", getAvgTime( ru_t_tot_time , ru_t_succ ) );
		System.out.printf( "AVG_RU_COMMIT_TIME     %.2f ms/update commit\n", getAvgTime( ru_t_com_time , ru_t_succ ) );
		System.out.printf( "AVG_RU_TX_PER_MS       %.2f update tx/ms\n", getOpsPerTime( ru_t_succ , ru_t_tot_time ) );
		
		// System.out.println();
		
		// System.out.printf( "AVG_READ_TX_PER_MS     %.4f read tx/ms\n", getOpsPerTime( r_t_succ, r_t_tot_time ) );
		// System.out.printf( "AVG_READ_COMMIT_PER_MS %.4f read commits/ms\n", getOpsPerTime( r_t_succ , r_t_com_time ) );
		
		// System.out.printf( "AVG_RU_TX_PER_MS       %.4f update tx/ms\n", getOpsPerTime( ru_t_succ , ru_t_tot_time ) );
		// System.out.printf( "AVG_RU_COMMIT_PER_MS   %.4f update commits/ms\n", getOpsPerTime( ru_t_succ , ru_t_com_time ) );
		
		System.out.println();

		System.exit ( 0 );
	}

	public static float getAvgTime( long a, int b )
	{
		// if ( a == 0 ) return 0;
		return ((float) a)/b;
	}

	public static float getOpsPerTime( int ops, long time )
	{
		return ((float) ops)/time;
	}
}

class KillThread implements Runnable
{
	public KillThread()
	{
	}

	public void run()
	{
		try
		{
			Thread.currentThread().sleep( 1000*SibenchClient.duration * 5 );
			System.exit ( 0 );
		}
		catch ( Exception e )
		{
		}
	}

}

class Stats {
	private float expectedValueSum, varianceSum;
	private int count;

	public void addValue(float val) {
		this.expectedValueSum += val;
		this.varianceSum += val * val;
		this.count++;
	}

	public double getExpectedValue() {
		return this.expectedValueSum / this.count; // mu = p * sum(x_i);
	}
	public double getVariance() {
		double expectedValue = this.getExpectedValue();
		return 1.0 / this.count * this.varianceSum - expectedValue * expectedValue; // var = p * sum(x_i^2) - mu^2
	}
	public double getStandardDeviation() {
		double variance = this.getVariance();
		return Math.sqrt(variance);
	}
	public double getStandardError() {
		double stddev = this.getStandardDeviation();
		return stddev / Math.sqrt(this.count);
	}

	public double subtractStddev(double sd1, double sd2) {
		return Math.sqrt(sd1 * sd1 + sd2 * sd2);
	}
}
