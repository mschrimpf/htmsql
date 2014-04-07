import java.util.*;
import java.sql.*;

public class DBGen extends Common
{
	public int num_item;

	public DBGen()
	{ 
		this.num_item  = Integer.parseInt( props.getProperty ( "DB.TableSize" , "100000" ) );
	}

	public void generate() throws Exception
	{
		Connection conn = getDBConnection();
		conn.setAutoCommit( true );
		Statement stmt = conn.createStatement();
		Random r = new Random();
		for( int i = 0 ; i < num_item ; i++ )
		{
			StringBuffer buf = new StringBuffer();
			buf.append( "INSERT INTO sibench0 ( b_key , b_int, b_value0, b_value1 , b_value2, b_value3, b_value4, " );
			buf.append( "b_value5, b_value6 , b_value7, b_value8, b_value9  ) values (" );
			buf.append( i ).append(" , " ).append( r.nextInt( 10000000 ) ).append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "');" );

			stmt.executeUpdate( buf.toString() );
		}

		for( int i = 0 ; i < num_item ; i++ )
		{
			StringBuffer buf = new StringBuffer();
			buf.append( "INSERT INTO sibench1 ( b_key , b_int, b_value0, b_value1 , b_value2, b_value3, b_value4, " );
			buf.append( "b_value5, b_value6 , b_value7, b_value8, b_value9  ) values (" );
			buf.append( i ).append(" , " ).append( r.nextInt( 10000000 ) ).append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "');" );

			stmt.executeUpdate( buf.toString() );
		}

		for( int i = 0 ; i < num_item ; i++ )
		{
			StringBuffer buf = new StringBuffer();
			buf.append( "INSERT INTO sibench2 ( b_key , b_int, b_value0, b_value1 , b_value2, b_value3, b_value4, " );
			buf.append( "b_value5, b_value6 , b_value7, b_value8, b_value9  ) values (" );
			buf.append( i ).append(" , " ).append( r.nextInt( 10000000 ) ).append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "'" );
			buf.append( " , '" ).append( getString( 51, r ) ).append( "');" );

			stmt.executeUpdate( buf.toString() );
		}


		stmt.close();
		conn.close();
	}

	public static void main(String[] args ) throws Exception
	{
		DBGen gen = new DBGen();
		gen.generate();

	}
}
