#ifndef _DUEL_SCENE_HANDLER_H_
#define _DUEL_SCENE_HANDLER_H_

#include "utils/command.h"
#include "utils/bufferutil.h"

#include "../scene_mgr.h"

namespace ygopro
{
    
    class DuelScene;
    class FieldBlock;
    class FieldCard;
    class InfoPanel;
    struct DuelMessage {
        uint8_t msg_type = 0;
        uint8_t* msg = nullptr;
        size_t len = 0;
    };
    
    extern int32_t host_player;
    extern std::array<std::shared_ptr<FieldBlock>, 17> field_blocks[2];
    extern std::vector<std::shared_ptr<FieldCard>> m_zone[2];
    extern std::vector<std::shared_ptr<FieldCard>> s_zone[2];
    extern std::vector<std::shared_ptr<FieldCard>> deck[2];
    extern std::vector<std::shared_ptr<FieldCard>> hand[2];
    extern std::vector<std::shared_ptr<FieldCard>> extra[2];
    extern std::vector<std::shared_ptr<FieldCard>> grave[2];
    extern std::vector<std::shared_ptr<FieldCard>> banished[2];
    
    class DuelSceneHandler : public SceneHandler {
    public:
        DuelSceneHandler(std::shared_ptr<DuelScene> pscene);
        ~DuelSceneHandler();
        virtual void BeginHandler();
        virtual bool UpdateHandler();
        virtual void MouseMove(int32_t x, int32_t y);
        virtual void MouseButtonDown(int32_t button, int32_t mods, int32_t x, int32_t y);
        virtual void MouseButtonUp(int32_t button, int32_t mods, int32_t x, int32_t y);
        virtual void MouseWheel(float deltax, float deltay);
        virtual void KeyDown(int32_t key, int32_t mods);
        virtual void KeyUp(int32_t key, int32_t mods);
        
        void InitField();
        std::shared_ptr<FieldCard> AddCard(uint32_t code, int32_t side, int32_t zone, int32_t seq, int32_t subs);
        std::shared_ptr<FieldCard> GetCard(int32_t side, int32_t zone, int32_t seq, int32_t subs);
        std::shared_ptr<FieldCard> RemoveCard(int32_t side, int32_t zone, int32_t seq, int32_t subs);
        void MoveCard(std::shared_ptr<FieldCard> pcard, int32_t toside, int32_t tozone, int32_t toseq, int32_t tosubs);
        void ChangePos(std::shared_ptr<FieldCard> pcard, int32_t pos);
        void UpdateHandpos(int32_t pid, int32_t tm);
        
        inline int32_t LocalPlayer(int32_t pid) { return (host_player == 0) ? pid : (1 - pid); }
        void ClearField();
        void InitHp(int32_t pid, int32_t hp);
        void AddChain(uint32_t code, int32_t side, int32_t zone, int32_t seq, int32_t subs, int32_t tside, int32_t tzone, int32_t tseq);
        
        template<typename... ACTS>
        void PushMessageActions(ACTS... acts) {
            message_lock = true;
            auto ptr = std::make_shared<ActionSequence<int64_t>>(std::forward<ACTS>(acts)...);
            ptr->Push(std::make_shared<ActionCallback<int64_t>>([this](){ message_lock = false; }));
            SceneMgr::Get() << ptr;
        }

        void PushMessageActions(const std::vector<std::shared_ptr<Action<int64_t>>>& lst) {
            message_lock = true;
            auto ptr = std::make_shared<ActionSequence<int64_t>>();
            for(auto& act : lst)
                ptr->Push(act);
            ptr->Push(std::make_shared<ActionCallback<int64_t>>([this](){ message_lock = false; }));
            SceneMgr::Get() << ptr;
        }
        int32_t SolveMessage(uint8_t msg_type, BufferUtil& reader);
        
    protected:
        std::weak_ptr<DuelScene> duel_scene;
        
        bool btnDown[2] = {false};
        v2i btnPos[2];
        v2i click_pos = {0, 0};
        int64_t show_info_time = 0;
        std::weak_ptr<FieldBlock> pre_block;
        std::weak_ptr<FieldCard> pre_card;
        std::shared_ptr<InfoPanel> info_panel;
        bool message_lock = false;
        CommandListMT<DuelMessage> messages;
    };
    
}

#endif
