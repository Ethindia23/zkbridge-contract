// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract Hasher {
    uint256 p = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    uint256[20] c = [
  0,
  62757308744152041078486880457024489723280677212959605556344880052256809812729,
  90955569528588994838518954353579066923759438022976182234384903729101764391871,
  6528278064144028313272559874053767390071778082806425920667006322892910015379,
  48600491728573810178260116585510838774184215686286529061302536301382080459448,
  77229146755330411676100327155408166779271727465653476137635313214029254968999,
  109491168963055041505171632093721820721676582526192664613268102193394768236150,
  93413479541499025737672913692574512226017555751847188207185048420641371951341,
  18095995412560581991966330003426147093581709770451569641593283509691723837999,
  11185628050516967224204011410141959453801145929159507187973798202736366111027,
  17318719119024973928954385595724898857511184379500143796206250220350740792602,
  96190662392984151251770611595407892223961437865739004151708022791354853813855,
  26732126645417167883398906115187452994230900200075752967430403006830630517915,
  10807088155038903998540605126483265243093518583593917638061052446718490385522,
  44038534769524506692424472691380322442908127089623978636272752445541209324835,
  25765252728866021358027006543692164070566012804206246582906804049676217680186,
  58937719037008695682376771271419693031930871875647362557836206918985083239425,
  80869936683392767443542904062586629554211569764249310891061929752268707887362,
  13021502834197385162187876398945054421280992751940669990266480602190749893262,
  44130811281419141421062168458697749345948840942524201257651192398526796478280
    ];

    function MiMC5Feistel(uint256 _iL, uint256 _iR, uint256 _k) internal view returns(uint256 oL, uint256 oR) {
        uint8 nRounds = 20;

        uint256 lastL = _iL;
        uint256 lastR = _iR;

        uint256 mask;
        uint256 mask2;
        uint256 mask4;
        uint256 temp;

        for(uint8 i = 0; i < nRounds; i++){
            mask = addmod(lastR, _k, p);
            mask = addmod(mask, c[i], p);
            mask2 = mulmod(mask, mask, p);
            mask4 = mulmod(mask2, mask2, p);
            mask = mulmod(mask4, mask, p);

            temp = lastR;
            lastR = addmod(lastL, mask, p);
            lastL = temp;
        }

        return (lastL, lastR);
    }
    function MiMC5Sponge(uint256[2] memory _ins, uint256 _k) external view returns(uint256 h) {
        uint256 lastR = 0;
        uint256 lastC = 0;

        for(uint8 i = 0; i < _ins.length; i++){
            lastR = addmod(lastR, _ins[i], p);
            (lastR, lastC) = MiMC5Feistel(lastR, lastC, _k);
        }

        h = lastR;
    }
}