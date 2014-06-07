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
		Connection conn = null;
		Statement stmt = null;
		try {
			conn = getDBConnection();
			stmt = getStatement(conn);
			Random r = new Random();
			
			// create tables
			for(int i=0; i <= 2; i++) {
				// drop
				stmt.executeUpdate( "DROP TABLE IF EXISTS sibench" + i );
				// create
				StringBuffer buf = new StringBuffer();
				buf.append("CREATE TABLE IF NOT EXISTS sibench" + i + "(");
				buf.append("b_key INTEGER NOT NULL PRIMARY KEY, ");
				buf.append("b_int INTEGER NOT NULL, ");
				for(int b=0; b < 10; b++) {
					buf.append("b_value" + b + " TEXT");
					if(b < 10 - 1)
						buf.append(", ");
				}
				buf.append(")");
				stmt.executeUpdate(buf.toString());
			}
			
			// insert values
			for(int s=0; s <= 2; s++)
			{
				for( int i = 0 ; i < num_item ; i++ )
				{
					StringBuffer buf = new StringBuffer();
					buf.append( "INSERT INTO sibench" + s + " ( b_key , b_int, b_value0, b_value1 , b_value2, b_value3, b_value4, " );
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
			}
		} finally {
			stmt.close();
			conn.close();
		}
	}

	public static void main(String[] args ) throws Exception
	{
		DBGen gen = new DBGen();
		gen.generate();

	}
}
