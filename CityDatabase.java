import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;

import java.util.List;
import java.util.ArrayList;
import java.util.LinkedList;

import java.util.Set;
import java.util.HashSet;
import java.util.TreeSet;

import java.util.Map;
import java.util.HashMap;
import java.util.TreeMap;


public class CityDatabase
{
	
	private static TreeMap<String, TreeSet<String>> cities;
	
	
	// Fields
	//-----------------------------------------------------------------
	
	
	// Constructors
	//-----------------------------------------------------------------
	public CityDatabase()
	{
		cities = new TreeMap <String, TreeSet<String>>();
		
		
		try
		{
			Scanner fin = new Scanner(new File("Cities.txt"));
			
			while (fin.hasNextLine())
			{
				String cityEntry = fin.nextLine();
				String[] entryParts = cityEntry.split(", |\\t");
				
				//System.out.println(entryParts[2]);
				
				String city = entryParts[0];
				String state = entryParts[1];
				int population = Integer.parseInt(entryParts[2]);
				
				if (!cities.containsKey(state)) {
					TreeSet<String> treeCities = new TreeSet<String>();
					treeCities.add(city);
					cities.put(state, treeCities);	
				}
				else
				{
					TreeSet<String> treeCities = cities.get(state);
					treeCities.add(city);
			//		cities.put(state, treeCities);
				}
				
				// TODO: Add city, state, and population to your ADTs.
				
			}
			
			
			fin.close();
		}
		catch (FileNotFoundException e)
		{
			System.out.println("ERROR: Could not load database.");
		}
	}
	
	// Methods
	//-----------------------------------------------------------------
	
	public static String getCities(String state)
	{
		return cities.get(state).toString();
		
	}

	
	// Driver (main) Method
	//-----------------------------------------------------------------
	public static void main(String[] args)
	{
		
		// Instantiate/initialize a CityDatabase
		CityDatabase city = new CityDatabase();
		Scanner scan = new Scanner(System.in);
		// Repeat the following until the user types 'quit'...
		String input = " ";
		while(!input.equalsIgnoreCase("quit"))
		{
		   System.out.println("Input a state abbreviation or 'quit'.");
		   input = scan.next();
		   
		   if(!input.equals("quit"))
		   {
			   System.out.println(city.getCities(input));
		   }
		   else{
			   System.out.println("Quitting... XD");
			   
		   }
		   
		}
		   scan.close();
		

		
		// Repeat the following until the user types 'quit'...
		//   ...Prompt the user to input a state abbreviation or 'quit'
		//   ...Print the list of cities in the user-specified state
		//        ...Basic assignment: List cities in alphabetical order
		//        ...Advanced assignment: List cities in order of population
		
		
		
		
	
		   System.exit(0);
	
}
}

