import java.util.*;
import java.sql.*;

public class Cleanup extends Common
{
	public void clean() throws Exception
	{
		Connection conn = getDBConnection();
		conn.setAutoCommit( true );
		Statement stmt = conn.createStatement();
		Random r = new Random();
		
		// drop db
		stmt.executeUpdate( "DROP DATABASE IF EXISTS txbench" );
		
		stmt.close();
		conn.close();
	}

	public static void main(String[] args ) throws Exception
	{
		Cleanup cleanup = new Cleanup();
		cleanup.clean();
	}
}
