import java.util.*;
import java.sql.*;
import java.io.*;

public abstract class Common
{
	private String db_url = "";
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
			db_url = props.getProperty ( "DB.Url" , "jdbc:postgresql://129.78.97.46:5432/sibench" );

			dbprops.setProperty("user", db_user );
			dbprops.setProperty("password",db_pass );
			Class.forName("org.postgresql.Driver" );
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
