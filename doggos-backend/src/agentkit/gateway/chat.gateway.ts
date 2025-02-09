import {
  WebSocketGateway,
  SubscribeMessage,
  MessageBody,
  OnGatewayConnection,
  OnGatewayDisconnect,
  WebSocketServer,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';

@WebSocketGateway({ cors: { origin: '*' } })
export class ChatGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer() server: Server;

  private connectedClients = new Map<
    string,
    { socket: Socket; messages: number; lastMessageTime: number }
  >();

  private readonly MESSAGE_LIMIT = 5; // Max messages allowed
  private readonly TIME_WINDOW = 10 * 1000; // Time window in milliseconds (10s)

  handleConnection(client: Socket) {
    console.log(`Client connected: ${client.id}`);
    this.connectedClients.set(client.id, {
      socket: client,
      messages: 0,
      lastMessageTime: Date.now(),
    });
  }

  handleDisconnect(client: Socket) {
    console.log(`Client disconnected: ${client.id}`);
    this.connectedClients.delete(client.id);
  }

  @SubscribeMessage('message')
  handleMessage(
    @MessageBody() data: { sender: string; message: string },
    client: Socket,
  ) {
    const clientData = this.connectedClients.get(client.id);

    if (clientData) {
      const now = Date.now();
      const timeElapsed = now - clientData.lastMessageTime;

      if (timeElapsed > this.TIME_WINDOW) {
        // Reset the message count after TIME_WINDOW has passed
        clientData.messages = 0;
        clientData.lastMessageTime = now;
      }

      if (clientData.messages >= this.MESSAGE_LIMIT) {
        console.warn(`Rate limit exceeded for client ${client.id}`);
        client.emit('rate_limit_exceeded', {
          message: 'Rate limit exceeded. Try again later.',
        });
        return;
      }

      clientData.messages += 1;
      clientData.lastMessageTime = now;

      console.log('Received message:', data);
      this.server.emit('message', data);
    }
  }
}
