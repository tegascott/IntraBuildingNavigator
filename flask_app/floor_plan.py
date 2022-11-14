from enum import Enum, auto
from typing import List


import networkx as nx
import matplotlib.pyplot as plt

class Node:
    def __init__(self, name: str):
        self.name = name

    def __str__(self):
        return str(self.name)

    def __eq__(self, other):
        return self.name == other.name

    def __hash__(self):
        return hash(self.name)

# types of nodes based on: https://www.researchgate.net/publication/277318124_Generation_of_navigation_graphs_for_indoor_space 
class Room(Node):
    pass
class Portal(Node):
    pass
class Stairwell(Node):
    pass
class Elevator(Node):
    pass


class FloorPlan:
    def __init__(self, name: str = ""):
        self.name = name
        self.graph = nx.Graph()

    def __str__(self):
        return str(self.name)

    def __hash__(self):
        hash(self.name)

    def __eq__(self):
        return ()

    def add_room(self, name: str):
        self.graph.add_node(Room(name))

    def add_portal(self, name: str):
        self.graph.add_node(Portal(name))

    def add_edge(self, start_name: str, end_name: str):
        self.graph.add_edge(Room(start_name), Room(end_name))

    def add_room_to_portal_edge(self, room: str, portal: str):
        self.graph.add_edge(Room(room), Portal(portal))

    def add_portal_to_portal_edge(self, start_portal: str, end_portal: str):
        self.graph.add_edge(Portal(start_portal), Portal(end_portal))

    def draw_graph(self):
        nx.draw_networkx(self.graph)
        plt.show()


# class Edge:
#     # connection between two nodes (bidirectional)
#     def __init__(self, start_node, end_node, distance: int = 1):
#         if not isinstance(start_node, Node) or not isinstance(end_node, Node):
#             raise TypeError('Node type expected')
#
#         self.start_node = start_node
#         self.end_node = end_node
#         self.distance = distance
#
#     def __str__(self):
#         return "{} <-> {}".format(self.start_node, self.end_node)


# class FloorPlan:
#     # floor plan is a dictionary of Nodes to all of their connected Edges
#     def __init__(self, name: str):
#         self.name = name
#         self._graph = {}
#
#     def __str__(self):
#         output = ""
#         for node, edges in self._graph.items():
#             output += ("\n" + str(node) + " : ")
#             for edge in edges:
#                 output += ("\n" + "\t" + str(edge))
#         return output
#
#     def add_node(self, node: Node, edges: List[Edge] = []):
#         self._graph[node] = edges
#
#     def add_edges_to_node(self, node: Node, edges: List[Edge]):
#         for edge in edges:
#             if edge not in self._graph[node]:
#                 self._graph[node].append(edge)
#
#     def add_edges_by_node_name(self, node_name, edges):
#         for node in self._graph:
#             if node.name == node_name:
#                 for edge in edges:
#                     self._graph[node].append(edge)
#
#     def add_edge(self, room: Edge):
#         start_node = room.start_node
#         end_node = room.end_node
#         self.add_edges_to_node(start_node, [room])
#         self.add_edges_to_node(start_node, [room])
#
#     def add_room(self, room_name: str):
#         self.add_node(Room(room_name))
#
#     def add_consecutive_rooms(self, start_number: int, end_number: int):
#         for room_number in range(start_number, end_number+1):
#             self.add_room(Node("Room {}".format(room_number)))
#
#     def get_node_by_name(self, node_name):
#         for node in self._graph:
#             if node.name == node_name:
#                 return node


    


    