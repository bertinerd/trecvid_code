/*
 * Client.cpp
 *
 *  Created on: Feb 27, 2013
 *      Author: massimo
 */
//
//  Hello World client in C++
//  Connects REQ socket to tcp://localhost:5555
//  Sends "Hello" to server, expects "World" back
//
#include <zmq.hpp>
#include <string>
#include <iostream>
#include <fstream>

using namespace std;

/*
 *  The server provides two kind of information:
 *  list (l)  = list of all images in the DB;
 *  query (q) = search images similar to the given one;
 *  ping (p)  = alive test (reply with "pong")
 *
 *  message format for list:
 *      l
 *  message format for query:
 *      q image-file-pathname  max-results
 *
 *  examples (in cdvs format):
 *  	q /var/opt/queries/image-3994885.cdvs  15
 *  	q /var/images/myimg/pluto.cdvs   99
 *
 *  examples (in jpeg format):
 *      q /home/images/myquery-3374.jpg  35
 *
 *  output:
 *      number of output lines
 *  	ordered list of matching images and score
 *  example:
 *  	4
 *      buildings/myhouse-334.jpg  1.23
 *      buildings/myhouse-118.jpg  0.98
 *      buildings/myhouse-334.jpg  0.36
 *      buildings/myhouse-334.jpg  0.22
 *
 *  if the input file is a JPEG image, it is converted into cdvs and then used as query.
 *  if the input file is a CDVS descriptor, it is used as query immediately.
 */
int main (int argc, char **argv) {
    
    if(argc!=3) {
    	cout << "USAGE: ./mtclient <filePath> <nQueries>" << endl;
    	return 1;
    }
    string fileName = argv[1];
    int nQueries = atoi(argv[2]);
    string* queries = new string[nQueries];


    // string queryLine;
    int s = 0;
    //  Prepare our context and socket
    zmq::context_t context (1);
    zmq::socket_t socket (context, ZMQ_REQ);

    std::cout << "Connecting to cdvs server…" << std::endl;
    socket.connect ("tcp://arctic.cselt.it:5000");


    std::ifstream infile(argv[1]);

    for(int line=0; line<nQueries;line++) {
    	std::getline(infile, queries[s]);

    }	

    std::cout << "PROCESSING " << nQueries << " QUERIES..." << std::endl;		
     // Do n requests, waiting each time for a response
    for (int k = 0; k < nQueries; ++k) {
        string query = queries[k];
        cout << query << endl;
        zmq::message_t request (query.size());
        memcpy ((void *) request.data (), query.data(), query.size());
        std::cout << "Sending query: " << query << std::endl;
        socket.send (request);

        //  Get the reply.
        zmq::message_t reply;
        socket.recv (&reply);
        char *cstring = new char [reply.size() + 1];
        memcpy (cstring, reply.data(), reply.size());
        cstring [reply.size()] = 0;
        std::cout << "Received: " << cstring << std::endl;
        delete[] cstring;
    }
    
    return 0;
}
