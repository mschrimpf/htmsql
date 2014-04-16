import java.util.*;
import java.sql.*;
import java.io.*;

public abstract class Common
{
	private String db_url = "";
	private String db_database = "";
	private String db_user = "";
	private String db_pass = "";
	private Properties dbprops;
	public static Properties props ;

	static
	{
		try
		{
			props = new Properties();
			props.load( new FileInputStream ( System.getProperty( "configure" , "config.txt" ) ) );
		}
		catch ( Exception e )
		{
			e.printStackTrace();
			System.exit ( 0 );
		}
	}

	public Common()
	{

		try
		{
			dbprops = new Properties();
			
			db_user = props.getProperty ( "DB.User", "postgres" );
			db_pass = props.getProperty ( "DB.Pass" , "");
//			db_url = props.getProperty ( "DB.Url" , "jdbc:postgresql://129.78.97.46:5432/txbench" );
			db_url = props.getProperty ( "DB.Url" , "jdbc:mysql://127.0.0.1:3306" );
			db_database = props.getProperty ( "DB.Database", "txbench" );

			dbprops.setProperty("user", db_user );
			dbprops.setProperty("password",db_pass );
//			Class.forName("org.postgresql.Driver" );
			Class.forName("com.mysql.jdbc.Driver" );
		}
		catch ( Exception e )
		{
			e.printStackTrace();
			System.exit ( 0 );
		}
	}

	public Connection getDBConnection()
	{
		try
		{
			Connection conn = DriverManager.getConnection(db_url, dbprops);
			Statement statement = conn.createStatement();
			statement.executeUpdate( "CREATE DATABASE IF NOT EXISTS " + db_database );
			statement.executeUpdate( "USE " + db_database );
			statement.close();
			return conn;
		}
		catch ( Exception e )
		{
			e.printStackTrace();
			System.exit ( 0 );
			return null;
		}
	}

       	public static String ALPHABET = "abcdefghijklmnopqrstuvwxyz";

	public static String getString( int l, Random r )
        {
                char[] ret = new char[l];

                for( int i = 0 ; i < l ; i++ )
                        ret[i] = ALPHABET.charAt( r.nextInt(26) );

                return new String(ret);
        }
}
